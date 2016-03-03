require 'mdl/cli'
require 'mdl/config'
require 'mdl/doc'
require 'mdl/kramdown_parser'
require 'mdl/ruleset'
require 'mdl/style'
require 'mdl/version'

require 'kramdown'

module MarkdownLint
  def self.run(argv=ARGV)
    cli = MarkdownLint::CLI.new
    cli.run(argv)
    ruleset = RuleSet.new
    unless Config[:skip_default_ruleset]
      ruleset.load_default
    end
    unless Config[:rulesets].nil?
      Config[:rulesets].each do |r|
        ruleset.load(r)
      end
    end
    rules = ruleset.rules
    Style.load(Config[:style], rules)
    # Rule option filter
    if Config[:rules]
      rules.select! {|r, v| Config[:rules][:include].include?(r) or
                     !(Config[:rules][:include] & v.aliases).empty? } \
        unless Config[:rules][:include].empty?
      rules.select! {|r, v| not Config[:rules][:exclude].include?(r) and
                     (Config[:rules][:exclude] & v.aliases).empty? } \
        unless Config[:rules][:exclude].empty?
    end
    # Tag option filter
    if Config[:tags]
      rules.select! {|r, v| not (v.tags & Config[:tags][:include]).empty? } \
        unless Config[:tags][:include].empty?
      rules.select! {|r, v| (v.tags & Config[:tags][:exclude]).empty? } \
        unless Config[:tags][:exclude].empty?
    end

    if Config[:list_rules]
      puts "Enabled rules:"
        rules.each do |id, rule|
          if Config[:verbose]
            puts "#{id} (#{rule.aliases.join(', ')}) [#{rule.tags.join(', ')}] - #{rule.description}"
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
            cli.cli_arguments[i] = %x(git ls-files '*.md' '*.markdown').split("\n")
          end
        else
          cli.cli_arguments[i] = Dir["#{filename}/**/*.{md,markdown}"]
        end
      end
    end
    cli.cli_arguments.flatten!

    status = 0
    cli.cli_arguments.each do |filename|
      puts "Checking #{filename}..." if Config[:verbose]
      doc = Doc.new_from_file(filename)
      filename = '(stdin)' if filename == "-"
      if Config[:show_kramdown_warnings]
        status = 2 if not doc.parsed.warnings.empty?
        doc.parsed.warnings.each do |w|
          puts "#{filename}: Kramdown Warning: #{w}"
        end
      end
      rules.sort.each do |id, rule|
        puts "Processing rule #{id}" if Config[:verbose]
        error_lines = rule.check.call(doc)
        next if error_lines.nil? or error_lines.empty?
        status = 1
        error_lines.each do |line|
          if Config[:show_aliases]
            puts "#{filename}:#{line}: #{rule.aliases.first || id} #{rule.description}"
          else
            puts "#{filename}:#{line}: #{id} #{rule.description}"
          end
        end
      end
    end
    exit status
  end
end
