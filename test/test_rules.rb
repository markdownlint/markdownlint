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

  Dir[File.expand_path('rule_tests/*.md', __dir__)].each do |filename|
    define_method("test_#{File.basename(filename, '.md')}") do
      do_lint(filename)
    end
  end
end
