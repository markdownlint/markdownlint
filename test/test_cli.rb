require_relative 'setup_tests'
require 'open3'
require 'set'
require 'fileutils'

class TestCli < Minitest::Test
  def test_help_text
    result = run_cli_with_rc_flag("--help")
    assert_match(/Usage: \S+ \[options\]/, result[:stdout])
    assert_equal(0, result[:status])
  end

  def test_default_ruleset_loading
    result = run_cli_with_rc_flag("-l")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["MD001"])
  end

  def test_show_alias_rule_list
    result = run_cli_with_rc_flag("-al")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["header-increment"])
  end

  def test_show_alias_processing_file
    result = run_cli_with_rc_flag("-a -r MD002", "## header2")
    assert_equal(1, result[:status])
    assert_equal("", result[:stderr])
    assert_match(/^\(stdin\):1: first-header-h1/, result[:stdout])
  end

  def test_skipping_default_ruleset_loading
    result = run_cli_with_rc_flag("-ld")
    assert_rules_enabled(result, [], true)
  end

  def test_custom_ruleset_loading
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-ldu #{my_ruleset}")
    assert_rules_enabled(result, ["MY001"], true)
    assert_ran_ok(result)
  end

  def test_show_alias_rule_without_alias
    # Tests that when -a is given, but the rule doesn't have an alias, it
    # prints the rule ID instead.
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-ladu #{my_ruleset}")
    assert_rules_enabled(result, ["MY001"], true)
    assert_ran_ok(result)
  end

  def test_custom_ruleset_processing_success
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-du #{my_ruleset}", "Hello World")
    assert_equal("", result[:stdout])
    assert_ran_ok(result)
  end

  def test_custom_ruleset_processing_failure
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-du #{my_ruleset}", "Goodbye world")
    assert_equal(1, result[:status])
    assert_match(/^\(stdin\):1: MY001/, result[:stdout])
    assert_equal("", result[:stderr])
  end

  def test_custom_ruleset_processing_failure_with_show_alias
    # The custom rule doesn't have an alias, so the output should be identical
    # to that without show_alias enabled.
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-dau #{my_ruleset}", "Goodbye world")
    assert_equal(1, result[:status])
    assert_match(/^\(stdin\):1: MY001/, result[:stdout])
    assert_equal("", result[:stderr])
  end

  def test_custom_ruleset_loading_with_default
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli_with_rc_flag("-lu #{my_ruleset}")
    assert_rules_enabled(result, ["MD001", "MY001"])
    assert_ran_ok(result)
  end

  def test_rule_inclusion_cli
    result = run_cli_with_rc_flag("-r MD001 -l")
    assert_rules_enabled(result, ["MD001"], true)
    assert_ran_ok(result)
  end

  def test_rule_exclusion_cli
    result = run_cli_with_rc_flag("-r ~MD001 -l")
    assert_rules_disabled(result, ["MD001"])
    assert_ran_ok(result)
  end

  def test_rule_inclusion_with_exclusion_cli
    result = run_cli_with_rc_flag("-r ~MD001,MD039 -l")
    assert_rules_enabled(result, ["MD039"], true)
    assert_ran_ok(result)
  end

  def test_tag_inclusion_cli
    result = run_cli_with_rc_flag("-t headers -l")
    assert_rules_enabled(result, ["MD001", "MD002", "MD003"])
    assert_rules_disabled(result, ["MD004", "MD005", "MD006"])
    assert_ran_ok(result)
  end

  def test_tag_exclusion_cli
    result = run_cli_with_rc_flag("-t ~headers -l")
    assert_ran_ok(result)
    assert_rules_disabled(result, ["MD001", "MD002", "MD003"])
    assert_rules_enabled(result, ["MD004", "MD005", "MD006"])
  end

  def test_rule_inclusion_config
    result = run_cli_with_rc_flag("-l", "", "mdlrc_enable_rules")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["MD001", "MD002"], true)
  end

  def test_rule_exclusion_config
    result = run_cli_with_rc_flag("-l", "", "mdlrc_disable_rules")
    assert_ran_ok(result)
    assert_rules_disabled(result, ["MD001", "MD002"])
    assert_rules_enabled(result, ["MD003", "MD004"])
  end

  def test_mdlrc_loading_from_current_dir_by_default
    with_mdlrc("mdlrc_disable_rules") do
      result = run_cli_without_rc_flag("-l", "")
      assert_ran_ok(result)
      assert_rules_disabled(result, ["MD001", "MD002"])
      assert_rules_enabled(result, ["MD003", "MD004"])
    end
  end

  def test_tag_inclusion_config
    result = run_cli_with_rc_flag("-l", "", "mdlrc_enable_tags")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["MD001", "MD002", "MD009", "MD010"])
    assert_rules_disabled(result, ["MD004", "MD005"])
  end

  def test_tag_exclusion_config
    result = run_cli_with_rc_flag("-l", "", "mdlrc_disable_tags")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["MD004", "MD030", "MD032"])
    assert_rules_disabled(result, ["MD001", "MD005"])
  end

  def test_rule_inclusion_alias_cli
    result = run_cli_with_rc_flag("-l -r header-increment")
    assert_ran_ok(result)
    assert_rules_enabled(result, ["MD001"], true)
  end

  def test_rule_exclusion_alias_cli
    result = run_cli_with_rc_flag("-l -r ~header-increment")
    assert_ran_ok(result)
    assert_rules_disabled(result, ["MD001"])
    assert_rules_enabled(result, ["MD002"])
  end

  def test_directory_scanning
    path = File.expand_path("./fixtures/dir_with_md_and_markdown", File.dirname(__FILE__))
    result = run_cli_with_rc_flag("#{path}")
    files_with_issues = result[:stdout].split("\n").map { |l| l.split(":")[0] }.sort
    assert_equal(files_with_issues, ["#{path}/bar.markdown", "#{path}/foo.md"])
  end

  private

  def run_cli_with_rc_flag(args, stdin = "", mdlrc="default_mdlrc")
    run_cli("#{mdl_script} -c #{fixture_rc(mdlrc)} #{args}", stdin)
  end

  def run_cli_without_rc_flag(args, stdin = "")
    run_cli("#{mdl_script} #{args}", stdin)
  end

  def run_cli(command, stdin)
    result = {}
    result[:stdout], result[:stderr], result[:status] = \
      Open3.capture3("bundle", "exec", *command.split, :stdin_data => stdin)
    result[:status] = result[:status].exitstatus
    result
  end

  def mdl_script
    File.expand_path("../../bin/mdl", __FILE__)
  end

  def fixture_rc(filename)
    File.expand_path("../fixtures/#{filename}", __FILE__)
  end

  def assert_rules_enabled(result, rules, only_these_rules=false)
    # Asserts that the given rules are enabled given the output of mdl -l
    # If only_these_rules is set, then it asserts that the given rules and no
    # others are enabled.
    lines = result[:stdout].split("\n")
    assert_equal("Enabled rules:", lines.first)
    lines.shift
    rules = rules.to_set
    enabled_rules = lines.map{ |l| l.split(" ").first }.to_set
    if only_these_rules
      assert_equal(rules, enabled_rules)
    else
      assert_equal(Set.new, rules - enabled_rules)
    end
  end

  def assert_rules_disabled(result, rules)
    # Asserts that the given rules are _not_ enabled given the output of mdl -l
    lines = result[:stdout].split("\n")
    assert_equal("Enabled rules:", lines.first)
    lines.shift
    rules = rules.to_set
    enabled_rules = lines.map{ |l| l.split(" ").first }.to_set
    assert_equal(Set.new, rules & enabled_rules)
  end

  def assert_ran_ok(result)
    assert_equal(0, result[:status])
    assert_equal("", result[:stderr])
  end

  def with_mdlrc(filename)
    FileUtils.cp(fixture_rc(filename), ".mdlrc")
    yield
  ensure
    File.delete(".mdlrc")
  end
end
