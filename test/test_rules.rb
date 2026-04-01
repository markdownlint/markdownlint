require_relative 'setup_tests'

class TestRules < Minitest::Test
  def get_expected_errors(lines)
    # Looks for lines tagged with {MD123} to signify that a rule is expected to
    # fire for this line. It also looks for lines tagged with {MD123:1} to
    # signify that a rule is expected to fire on another line (the line number
    # after the colon).
    expected_errors = {}
    re = /\{(MD\d+)(?::(\d+))?\}/
    lines.each_with_index do |line, num|
      m = re.match(line)
      while m
        expected_errors[m[1]] ||= []
        expected_line = if m[2]
                          m[2].to_i
                        else
                          num + 1 # 1 indexed lines
                        end
        expected_errors[m[1]] << expected_line
        m = re.match(line, m.end(0))
      end
    end
    expected_errors
  end

  def do_lint(filename)
    # Check for a test_case_style.rb style file for individual tests
    style_file = filename.sub(/.md$/, '_style.rb')
    unless File.exist?(style_file)
      style_file = "#{File.dirname(filename)}/default_test_style.rb"
    end

    ruleset = MarkdownLint::RuleSet.new
    ruleset.load_default
    rules = ruleset.rules
    style = MarkdownLint::Style.load(style_file, rules)
    rules.select! { |r| style.rules.include?(r) }

    doc = MarkdownLint::Doc.new(File.read(filename))
    expected_errors = get_expected_errors(doc.lines)
    actual_errors = {}
    rules.sort.each do |id, rule|
      error_lines = rule.check.call(doc)
      actual_errors[id] = error_lines if error_lines && !error_lines.empty?
    end
    assert_equal expected_errors, actual_errors
  end

  def do_fix_lint(filename)
    style_file = filename.sub(/.md$/, '_style.rb')
    unless File.exist?(style_file)
      style_file = "#{File.dirname(filename)}/default_test_style.rb"
    end

    ruleset = MarkdownLint::RuleSet.new
    ruleset.load_default
    rules = ruleset.rules
    style = MarkdownLint::Style.load(style_file, rules)
    rules.select! { |r| style.rules.include?(r) }

    # Only test if at least one enabled rule has a fix block
    fixable_rules = rules.select { |_id, rule| rule.fix }
    return if fixable_rules.empty?

    text = File.read(filename)
    doc = MarkdownLint::Doc.new(text)
    expected_errors = get_expected_errors(doc.lines)

    # Only proceed if there are expected errors for fixable rules
    fixable_error_ids = expected_errors.keys & fixable_rules.keys
    return if fixable_error_ids.empty?

    # Apply fixes one rule at a time with re-parse, matching the real flow
    fixable_rules.sort.each do |_id, rule|
      doc = MarkdownLint::Doc.new(text.dup)
      error_lines = rule.check.call(doc)
      next if error_lines.nil? || error_lines.empty?

      rule.fix.call(doc, error_lines)
      text = doc.to_s
    end

    # Re-parse and check that fixable errors are gone
    fixed_doc = MarkdownLint::Doc.new(text)
    fixable_error_ids.each do |id|
      rule = fixable_rules[id]
      remaining = rule.check.call(fixed_doc)
      remaining = [] if remaining.nil?
      assert_empty remaining,
                   "#{File.basename(filename)}: #{id} fix left errors on " \
                   "lines #{remaining.inspect}"
    end
  end

  Dir[File.expand_path('rule_tests/*.md', __dir__)].each do |filename|
    define_method("test_#{File.basename(filename, '.md')}") do
      do_lint(filename)
    end
    define_method("test_fix_#{File.basename(filename, '.md')}") do
      do_fix_lint(filename)
    end
  end
end
