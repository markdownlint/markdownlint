require_relative 'setup_tests'
require 'open3'
require 'set'
require 'erb'
require 'fileutils'
require 'json'

class TestCli < Minitest::Test
  def test_help_text
    result = run_cli('--help')
    assert_match(/Usage: \S+ \[options\]/, result[:stdout])
    assert_equal(0, result[:status])
  end

  def test_json_output
    result = run_cli_with_input('-j', "# header\n")
    assert_ran_ok(result)
    expected = File.read('test/fixtures/output/json/without_matches.json')
    assert_equal(expected, result[:stdout])
  end

  def test_json_output_with_matches
    result = run_cli_with_input('-j -r MD002', "## header2\n")
    assert_equal(1, result[:status])
    assert_equal('', result[:stderr])
    expected = File.read('test/fixtures/output/json/with_matches.json')
    assert_equal(expected, result[:stdout])
  end

  def test_sarif_output
    result = run_cli_with_input('-S', "# header\n")
    assert_ran_ok(result)
    expected = ERB.new(File.read('test/fixtures/output/sarif/without_matches.sarif')).result(binding)
    assert_equal(expected, result[:stdout])
  end

  def test_sarif_output_with_matches
    result = run_cli_with_input('-S -r MD002', "## header2\n")
    assert_equal(1, result[:status])
    assert_equal('', result[:stderr])
    expected = ERB.new(File.read('test/fixtures/output/sarif/with_matches.sarif')).result(binding)
    assert_equal(expected, result[:stdout])
  end

  def test_default_ruleset_loading
    result = run_cli('-l')
    assert_ran_ok(result)
    assert_rules_enabled(result, ['MD001'])
  end

  def test_show_alias_rule_list
    result = run_cli('-al')
    assert_ran_ok(result)
    assert_rules_enabled(result, ['header-increment'])
  end

  def test_show_alias_processing_file
    result = run_cli_with_input('-a -r MD002', "## header2\n")
    assert_equal(1, result[:status])
    assert_equal('', result[:stderr])
    assert_match(/^\(stdin\):1: first-header-h1/, result[:stdout])
  end

  def test_running_on_unicode_input
    result = run_cli_with_file_and_ascii_env("## header2 🚀\n")
    assert_equal(1, result[:status])
    assert_equal('', result[:stderr])
    assert_match(/MD002 First header should be a top level header/,
                 result[:stdout])
  end

  def test_skipping_default_ruleset_loading
    result = run_cli('-ld')
    assert_rules_enabled(result, [], true)
  end

  def test_custom_ruleset_loading
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli("-ldu #{my_ruleset}")
    assert_rules_enabled(result, ['MY001'], true)
    assert_ran_ok(result)
  end

  def test_show_alias_rule_without_alias
    # Tests that when -a is given, but the rule doesn't have an alias, it
    # prints the rule ID instead.
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli("-ladu #{my_ruleset}")
    assert_rules_enabled(result, ['MY001'], true)
    assert_ran_ok(result)
  end

  def test_custom_ruleset_processing_success
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli_with_input("-du #{my_ruleset}", 'Hello World')
    assert_equal('', result[:stdout])
    assert_ran_ok(result)
  end

  def test_custom_ruleset_processing_failure
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli_with_input("-du #{my_ruleset}", 'Goodbye world')
    assert_equal(1, result[:status])
    assert_match(/^\(stdin\):1: MY001/, result[:stdout])
    assert_equal('', result[:stderr])
  end

  def test_custom_ruleset_processing_failure_with_show_alias
    # The custom rule doesn't have an alias, so the output should be identical
    # to that without show_alias enabled.
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli_with_input("-dau #{my_ruleset}", 'Goodbye world')
    assert_equal(1, result[:status])
    assert_match(/^\(stdin\):1: MY001/, result[:stdout])
    assert_equal('', result[:stderr])
  end

  def test_custom_ruleset_loading_with_default
    my_ruleset = File.expand_path('fixtures/my_ruleset.rb', __dir__)
    result = run_cli("-lu #{my_ruleset}")
    assert_rules_enabled(result, %w{MD001 MY001})
    assert_ran_ok(result)
  end

  def test_rule_inclusion_cli
    result = run_cli('-r MD001 -l')
    assert_rules_enabled(result, ['MD001'], true)
    assert_ran_ok(result)
  end

  def test_rule_exclusion_cli
    result = run_cli('-r ~MD001 -l')
    assert_rules_disabled(result, ['MD001'])
    assert_ran_ok(result)
  end

  def test_rule_inclusion_with_exclusion_cli
    result = run_cli('-r ~MD001,MD039 -l')
    assert_rules_enabled(result, ['MD039'], true)
    assert_ran_ok(result)
  end

  def test_tag_inclusion_cli
    result = run_cli('-t headers -l')
    assert_rules_enabled(result, %w{MD001 MD002 MD003})
    assert_rules_disabled(result, %w{MD004 MD005 MD006})
    assert_ran_ok(result)
  end

  def test_tag_exclusion_cli
    result = run_cli('-t ~headers -l')
    assert_ran_ok(result)
    assert_rules_disabled(result, %w{MD001 MD002 MD003})
    assert_rules_enabled(result, %w{MD004 MD005 MD006})
  end

  def test_rule_inclusion_config
    result = run_cli_with_custom_rc_file('-l', 'mdlrc_enable_rules')
    assert_ran_ok(result)
    assert_rules_enabled(result, %w{MD001 MD002}, true)
  end

  def test_rule_exclusion_config
    result = run_cli_with_custom_rc_file('-l', 'mdlrc_disable_rules')
    assert_correctly_disabled(result)
  end

  def test_mdlrc_loading_from_current_dir_by_default
    inside_tmp_dir do |dir|
      with_mdlrc('mdlrc_disable_rules', dir) do
        result = run_cli_without_rc_flag('-l')
        assert_correctly_disabled(result)
      end
    end
  end

  def test_mdlrc_loading_ascends_until_it_finds_an_rc_file
    Dir.mktmpdir do |parent_dir|
      inside_tmp_dir(parent_dir) do
        with_mdlrc('mdlrc_disable_rules', parent_dir) do
          result = run_cli_without_rc_flag('-l')
          assert_correctly_disabled(result)
        end
      end
    end
  end

  def test_tag_inclusion_config
    result = run_cli_with_custom_rc_file('-l', 'mdlrc_enable_tags')
    assert_ran_ok(result)
    assert_rules_enabled(result, %w{MD001 MD002 MD009 MD010})
    assert_rules_disabled(result, %w{MD004 MD005})
  end

  def test_tag_exclusion_config
    result = run_cli_with_custom_rc_file('-l', 'mdlrc_disable_tags')
    assert_ran_ok(result)
    assert_rules_enabled(result, %w{MD004 MD030 MD032})
    assert_rules_disabled(result, %w{MD001 MD005})
  end

  def test_rule_inclusion_alias_cli
    result = run_cli('-l -r header-increment')
    assert_ran_ok(result)
    assert_rules_enabled(result, ['MD001'], true)
  end

  def test_rule_exclusion_alias_cli
    result = run_cli('-l -r ~header-increment')
    assert_ran_ok(result)
    assert_rules_disabled(result, ['MD001'])
    assert_rules_enabled(result, ['MD002'])
  end

  def test_directory_scanning
    path = File.expand_path(
      './fixtures/dir_with_md_and_markdown',
      File.dirname(__FILE__),
    )
    result = run_cli(path.to_s)
    lines_output = result[:stdout].lines
    interested_lines = lines_output[0...lines_output.index("\n")]
    files_with_issues = interested_lines.map { |l| l.split(':')[0] }.sort
    assert_equal(files_with_issues, ["#{path}/bar.markdown", "#{path}/foo.md"])
  end

  def test_ignore_front_matter
    path = File.expand_path('./fixtures/front_matter', File.dirname(__FILE__))
    files = ['jekyll_post.md', 'jekyll_post_2.md'].map do |f|
      File.join(path, f)
    end.join(' ')
    result = run_cli("-i -r MD001,MD041,MD034 #{files}")

    expected = <<~OUTPUT
      #{path}/jekyll_post.md:16: MD001 Header levels should only increment by one level at a time
      #{path}/jekyll_post_2.md:16: MD001 Header levels should only increment by one level at a time

      Further documentation is available for these failures:
       - MD001: https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md#md001---header-levels-should-only-increment-by-one-level-at-a-time
    OUTPUT

    assert_equal(result[:stdout], expected)
  end

  def test_unprintable_chars
    path = File.expand_path(
      './fixtures/unprintable_chars',
      File.dirname(__FILE__),
    )
    files = (1..3).map do |i|
      File.join(path, "test#{i}")
    end.join(' ')
    result = run_cli(files)

    assert_equal(result[:stdout], '')
  end

  def test_printing_url_links_in_tty
    result = run_cli_as_tty('-r MD002', "## header2\n")

    link_text = 'MD002'
    url = 'https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md#md002---first-header-should-be-a-top-level-header'
    expected_link = "\e]8;;#{url}\e\\#{link_text}\e]8;;\e\\"

    expected = <<~OUTPUT
      (stdin):1: #{expected_link} First header should be a top level header
    OUTPUT

    assert_equal(result[:stdout], expected)
  end

  def test_printing_url_links_outside_tty
    result = run_cli_with_input('-r MD002', "## header2\n")

    url = 'https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md#md002---first-header-should-be-a-top-level-header'

    expected = <<~OUTPUT
      (stdin):1: MD002 First header should be a top level header

      Further documentation is available for these failures:
       - MD002: #{url}
    OUTPUT

    assert_equal(result[:stdout], expected)
  end

  def test_docs_declaration
    ruleset1 = File.expand_path('./fixtures/docs_ruleset_1.rb', __dir__)
    ruleset2 = File.expand_path('./fixtures/docs_ruleset_2.rb', __dir__)

    result = run_cli_with_input("-d -u #{ruleset1},#{ruleset2}", "!\n")

    expected = <<~OUTPUT
      (stdin):1: MY002 Documents must start with A
      (stdin):1: MY003 Documents must start with B
      (stdin):1: MY004 Documents must start with C
      (stdin):1: MY005 Documents must start with D
      (stdin):1: MY006 Documents must start with E
      (stdin):1: MY007 Documents must start with F

      Further documentation is available for these failures:
       - MY002: https://example.com/static-docs
       - MY003: https://example.com/override-docs
       - MY004: https://example.com/MY004#364fe83d86ba1cdcc2ea87aec2fc5ec0
       - MY005: https://example.com/override-docs
       - MY006: https://example.com/later-declaration
       - MY007: https://example.com/dynamic-override/MY007#documents-must-start-with-f
    OUTPUT

    assert_equal(expected, result[:stdout])
  end

  def test_graceful_not_found
    file_path = 'a/file/that/does/not/exist.md'
    dir_path = 'a/folder/that/does/not/exist'

    file_result = run_cli(file_path)
    dir_result = run_cli(dir_path)

    file_expected = "Errno::ENOENT: No such file or directory - #{file_path}\n"
    dir_expected = "Errno::ENOENT: No such file or directory - #{dir_path}\n"

    # No stdout
    assert_equal('', file_result[:stdout])
    assert_equal('', dir_result[:stdout])

    # Statuses are 3
    assert_equal(3, file_result[:status])
    assert_equal(3, dir_result[:status])

    # Check error message is expected
    assert_equal(file_expected, file_result[:stderr])
    assert_equal(dir_expected, dir_result[:stderr])
  end

  private

  def run_cli_with_input(args, stdin)
    run_cmd("#{mdl_script} -c #{default_rc_file} #{args}", stdin)
  end

  def run_cli_as_tty(args, stdin)
    fake_tty = File.expand_path('./fixtures/fake_tty.rb', __dir__)
    run_cmd("#{mdl_script} -c #{default_rc_file} -u #{fake_tty} #{args}", stdin)
  end

  def run_cli_without_rc_flag(args)
    run_cmd("#{mdl_script} #{args}", '')
  end

  def run_cli(args)
    run_cmd("#{mdl_script} -c #{default_rc_file} #{args}", '')
  end

  def run_cli_with_custom_rc_file(args, filename)
    run_cmd("#{mdl_script} -c #{fixture_rc(filename)} #{args}", '')
  end

  def run_cli_with_file_and_ascii_env(content)
    Tempfile.create('foo') do |f|
      f.write(content)
      f.close

      run_cmd("ruby -E ASCII #{mdl_script} -c #{default_rc_file} #{f.path}", '')
    end
  end

  def run_cmd(command, stdin)
    result = {}
    result[:stdout], result[:stderr], result[:status] = \
      Open3.capture3('bundle', 'exec', *command.split, :stdin_data => stdin)
    result[:status] = result[:status].exitstatus
    result
  end

  def mdl_script
    File.expand_path('../bin/mdl', __dir__)
  end

  def fixture_rc(filename)
    File.expand_path("../fixtures/#{filename}", __FILE__)
  end

  def default_rc_file
    fixture_rc('default_mdlrc')
  end

  def inside_tmp_dir(base_dir = Dir.tmpdir)
    Dir.mktmpdir(nil, base_dir) do |dir|
      Dir.chdir(dir) { yield(dir) }
    end
  end

  def assert_rules_enabled(result, rules, only_these_rules = false)
    # Asserts that the given rules are enabled given the output of mdl -l
    # If only_these_rules is set, then it asserts that the given rules and no
    # others are enabled.
    lines = result[:stdout].split("\n")
    assert_equal('Enabled rules:', lines.first)
    lines.shift
    rules = rules.to_set
    enabled_rules = lines.map { |l| l.split.first }.to_set
    if only_these_rules
      assert_equal(rules, enabled_rules)
    else
      assert_equal(Set.new, rules - enabled_rules)
    end
  end

  def assert_rules_disabled(result, rules)
    # Asserts that the given rules are _not_ enabled given the output of mdl -l
    lines = result[:stdout].split("\n")
    assert_equal('Enabled rules:', lines.first)
    lines.shift
    rules = rules.to_set
    enabled_rules = lines.map { |l| l.split.first }.to_set
    assert_equal(Set.new, rules & enabled_rules)
  end

  def assert_ran_ok(result)
    assert_equal(0, result[:status])
    assert_equal('', result[:stderr])
  end

  def assert_correctly_disabled(result)
    assert_ran_ok(result)
    assert_rules_disabled(result, %w{MD001 MD002})
    assert_rules_enabled(result, %w{MD003 MD004})
  end

  def with_mdlrc(filename, dest_dir = Dir.pwd)
    rc_path = File.join(dest_dir, '.mdlrc')
    FileUtils.cp(fixture_rc(filename), rc_path)
    yield
  ensure
    File.delete(rc_path)
  end
end
