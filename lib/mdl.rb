require 'mdl/cli'
require 'mdl/config'
require 'mdl/doc'
require 'mdl/ruleset'
require 'mdl/style'
require 'mdl/version'

require 'kramdown'

module MarkdownLint
  def self.run
    cli = MarkdownLint::CLI.new
    cli.run
    rules = RuleSet.load_default
    unless Config[:style].include?("/") or Config[:style].end_with?(".rb")
      Config[:style] = File.expand_path(
        "../../lib/mdl/styles/#{Config[:style]}.rb", __FILE__)
    end
    style = Style.load(Config[:style], rules)
    rules.select! {|r| style.rules.include?(r)}

    status = 0
    cli.cli_arguments.each do |filename|
      puts "Checking #{filename}..." if Config[:verbose]
      doc = Doc.new_from_file(filename)
      if Config[:show_kramdown_warnings]
        status = 2 if not doc.parsed.warnings.empty?
        doc.parsed.warnings.each do |w|
          puts "#{filename}: Kramdown Warning: #{w}"
        end
      end
      rules.sort.each do |id, rule|
        if Config[:rules] and not Config[:rules].include?(id)
          puts "Skipping rule #{id} (rule limit)" if Config[:verbose]
          next
        end
        if Config[:tags] and (rule.tags & Config[:tags]).empty?
          puts "Skipping rule #{id} (tag limit)" if Config[:verbose]
          next
        end
        puts "Processing rule #{id}" if Config[:verbose]
        error_lines = rule.check.call(doc)
        next if error_lines.nil? or error_lines.empty?
        status = 1
        error_lines.each do |line|
          puts "#{filename}:#{line}: #{id} #{rule.description}"
        end
      end
    end
    exit status
  end
end
