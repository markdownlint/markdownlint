require_relative 'mdl/formatters/sarif'
require_relative 'mdl/cli'
require_relative 'mdl/config'
require_relative 'mdl/doc'
require_relative 'mdl/kramdown_parser'
require_relative 'mdl/ruleset'
require_relative 'mdl/style'
require_relative 'mdl/version'

require 'kramdown'
require 'mixlib/shellout'

# Primary MDL container
module MarkdownLint
  def self.run(argv = ARGV)
    cli = MarkdownLint::CLI.new
    cli.run(argv)
    ruleset = RuleSet.new
    ruleset.load_default unless Config[:skip_default_ruleset]
    Config[:rulesets]&.each do |r|
      ruleset.load(r)
    end
    rules = ruleset.rules
    Style.load(Config[:style], rules)
    # Rule option filter
    if Config[:rules]
      unless Config[:rules][:include].empty?
        rules.select! do |r, v|
          Config[:rules][:include].include?(r) or
            !(Config[:rules][:include] & v.aliases).empty?
        end
      end
      unless Config[:rules][:exclude].empty?
        rules.select! do |r, v|
          !Config[:rules][:exclude].include?(r) and
            (Config[:rules][:exclude] & v.aliases).empty?
        end
      end
    end
    # Tag option filter
    if Config[:tags]
      rules.reject! { |_r, v| (v.tags & Config[:tags][:include]).empty? } \
        unless Config[:tags][:include].empty?
      rules.select! { |_r, v| (v.tags & Config[:tags][:exclude]).empty? } \
        unless Config[:tags][:exclude].empty?
    end

    if Config[:list_rules]
      puts 'Enabled rules:'
      rules.each do |id, rule|
        if Config[:verbose]
          puts "#{id} (#{rule.aliases.join(', ')}) [#{rule.tags.join(', ')}] " +
               "- #{rule.description}"
        elsif Config[:show_aliases]
          puts "#{rule.aliases.first || id} - #{rule.description}"
        else
          puts "#{id} - #{rule.description}"
        end
      end
      exit 0
    end

    # Recurse into directories
    cli.cli_arguments.each_with_index do |filename, i|
      if Dir.exist?(filename)
        if Config[:git_recurse]
          Dir.chdir(filename) do
            cli.cli_arguments[i] =
              Mixlib::ShellOut.new("git ls-files '*.md' '*.markdown'")
                              .run_command.stdout.lines
                              .map { |m| File.join(filename, m.strip) }
          end
        else
          cli.cli_arguments[i] = Dir["#{filename}/**/*.{md,markdown}"]
        end
      end
    end
    cli.cli_arguments.flatten!

    status = 0
    results = []
    docs_to_print = []
    cli.cli_arguments.each do |filename|
      puts "Checking #{filename}..." if Config[:verbose]
      unless filename == '-' || File.exist?(filename)
        warn(
          "#{Errno::ENOENT}: No such file or directory - #{filename}",
        )
        exit 3
      end
      doc = Doc.new_from_file(filename, Config[:ignore_front_matter])
      filename = '(stdin)' if filename == '-'
      if Config[:show_kramdown_warnings]
        status = 2 unless doc.parsed.warnings.empty?
        doc.parsed.warnings.each do |w|
          puts "#{filename}: Kramdown Warning: #{w}"
        end
      end
      rules.sort.each do |id, rule|
        puts "Processing rule #{id}" if Config[:verbose]
        error_lines = rule.check.call(doc)
        next if error_lines.nil? || error_lines.empty?

        status = 1
        error_lines.each do |line|
          line += doc.offset # Correct line numbers for any yaml front matter
          if Config[:json] || Config[:sarif]
            results << {
              'filename' => filename,
              'line' => line,
              'rule' => id,
              'aliases' => rule.aliases,
              'description' => rule.description,
              'docs' => rule.docs_url,
            }
          else
            linked_id = linkify(printable_id(rule), rule.docs_url)
            puts "#{filename}:#{line}: #{linked_id} " + rule.description.to_s
          end
        end

        # If we're not in JSON or SARIF mode (URLs are in the object), and we
        # cannot make real links (checking if we have a TTY is an OK heuristic
        # for that) then, instead of making the output ugly with long URLs, we
        # print them at the end. And of course we only want to print each URL
        # once.
        if !Config[:json] && !Config[:sarif] &&
           !$stdout.tty? && !docs_to_print.include?(rule)
          docs_to_print << rule
        end
      end
    end

    if Config[:json]
      require 'json'
      puts JSON.generate(results)
    elsif Config[:sarif]
      puts SarifFormatter.generate(rules, results)
    elsif docs_to_print.any?
      puts "\nFurther documentation is available for these failures:"
      docs_to_print.each do |rule|
        puts " - #{printable_id(rule)}: #{rule.docs_url}"
      end
    end
    exit status
  end

  def self.printable_id(rule)
    return rule.aliases.first if Config[:show_aliases] && rule.aliases.any?

    rule.id
  end

  # Creates hyperlinks in terminal emulators, if available: https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
  def self.linkify(text, url)
    return text unless $stdout.tty? && url

    "\e]8;;#{url}\e\\#{text}\e]8;;\e\\"
  end
end
