require_relative 'setup_tests'
require 'open3'

class TestCli < Minitest::Test
  def run_cli(args, stdin = "")
    mdl_script = File.expand_path("../../bin/mdl", __FILE__)
    result = {}
    result[:stdout], result[:stderr], result[:status] = \
      Open3.capture3(*(%W{bundle exec #{mdl_script}} + args.split),
                    :stdin_data => stdin)
    result[:status] = result[:status].exitstatus
    result
  end

  def test_help_text
    result = run_cli("--help")
    assert_match(/Usage: \S+ \[options\]/, result[:stdout])
    assert_equal(0, result[:status])
  end

  def test_default_ruleset_loading
    result = run_cli("-l")
    assert_match(/^Enabled rules:\nMD001/, result[:stdout])
  end

  def test_skipping_default_ruleset_loading
    result = run_cli("-ld")
    assert_match(/^Enabled rules:\n$/, result[:stdout])
  end

  def test_custom_ruleset_loading
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli("-ldu #{my_ruleset}")
    assert_equal(0, result[:status])
    assert_match(/^Enabled rules:\nMY001 -/, result[:stdout])
    assert_equal("", result[:stderr])
  end

  def test_custom_ruleset_processing_success
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli("-du #{my_ruleset}", "Hello World")
    assert_equal("", result[:stdout])
    assert_equal("", result[:stderr])
    assert_equal(0, result[:status])
  end

  def test_custom_ruleset_processing_failure
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli("-du #{my_ruleset}", "Goodbye world")
    assert_equal(1, result[:status])
    assert_match(/^\(stdin\):1: MY001/, result[:stdout])
    assert_equal("", result[:stderr])
  end

  def test_custom_ruleset_loading_with_default
    my_ruleset = File.expand_path("../fixtures/my_ruleset.rb", __FILE__)
    result = run_cli("-lu #{my_ruleset}")
    assert_equal(0, result[:status])
    assert_match(/^Enabled rules:\nMD001 -.*/, result[:stdout])
    assert_match(/MY001 -.*$/, result[:stdout])
    assert_equal("", result[:stderr])
  end
end
