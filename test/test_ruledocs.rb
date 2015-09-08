require_relative 'setup_tests'

# Ensures there is documentation for every rule, and that the
# descriptions/tags/etc in the rule match those in the documentation
class TestRuledocs < Minitest::Test
  @@ruleset = MarkdownLint::RuleSet.new
  @@ruleset.load_default
  @@rules = @@ruleset.rules

  def setup
    @ruledocs = load_ruledocs
  end

  def load_ruledocs
    rules = Hash.new({}) # Default to {} if no docs for the rule
    curr_rule = nil
    rules_file = File.expand_path('../../docs/RULES.md', __FILE__)
    File.read(rules_file).split("\n").each do |l|
      if l.match(/^## (MD\d+) - (.*)$/)
        rules[$1] = { :description => $2, :params => {} }
        curr_rule = $1
      elsif l.match(/^Tags: (.*)$/)
        rules[curr_rule][:tags] = $1.split(',').map{|i| i.strip.to_sym}
      elsif l.match(/^Aliases: (.*)$/)
        rules[curr_rule][:aliases] = $1.split(',').map{|i| i.strip}
      elsif l.match(/^Parameters: (.*)(\(.*\)?)$/)
        rules[curr_rule][:params] = $1.split(',').map{|i| i.strip.to_sym}
      end
    end
    rules
  end

  @@rules.each do |id, r|
    define_method("test_ruledoc_description_#{id}") do
      assert_equal r.description, @ruledocs[id][:description]
    end
    define_method("test_ruledoc_tags_#{id}") do
      assert_equal r.tags, @ruledocs[id][:tags]
    end
    define_method("test_ruledoc_aliases_#{id}") do
      assert_equal r.aliases, @ruledocs[id][:aliases]
    end
    define_method("test_ruledoc_params_#{id}") do
      assert_equal r.params.keys.sort, (@ruledocs[id][:params] || []).sort
    end
  end

  def test_ruledoc_for_every_rule
    # (and vice versa)
    assert_equal @@rules.keys, @ruledocs.keys
  end
end
