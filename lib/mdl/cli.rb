require 'mixlib/cli'

module MarkdownLint
  class CLI
    include Mixlib::CLI

    banner "Usage: #{File.basename($0)} [options] [FILE.md|DIR ...]"

    option :config_file,
      :short => '-c',
      :long => '--config FILE',
      :description => 'The configuration file to use',
      :default => '~/.mdlrc'

    option :verbose,
      :short => '-v',
      :long => '--[no-]verbose',
      :description => 'Increase verbosity',
      :boolean => true

    option :show_kramdown_warnings,
      :short => '-w',
      :long => '--[no-]warnings',
      :description => 'Show kramdown warnings',
      :boolean => true

    option :tags,
      :short => '-t',
      :long => '--tags TAG1,TAG2',
      :description => 'Only process rules with these tags',
      :proc => Proc.new { |v| toggle_list(v, true) }

    option :rules,
      :short => '-r',
      :long => '--rules RULE1,RULE2',
      :description => 'Only process these rules',
      :proc => Proc.new { |v| toggle_list(v) }

    option :style,
      :short => '-s',
      :long => '--style STYLE',
      :description => "Load the given style"

    option :list_rules,
      :short => '-l',
      :long => '--list-rules',
      :boolean => true,
      :description => "Don't process any files, just list enabled rules"

    option :git_recurse,
      :short => '-g',
      :long => '--git-recurse',
      :boolean => true,
      :description => "Only process files known to git when given a directory"

    option :help,
      :on => :tail,
      :short => '-h',
      :long => '--help',
      :description => 'Show this message',
      :boolean => true,
      :show_options => true,
      :exit => 0

    option :version,
      :on => :tail,
      :short => "-V",
      :long => "--version",
      :description => "Show version",
      :boolean => true,
      :proc => Proc.new { puts MarkdownLint::VERSION },
      :exit => 0

    def run(argv=ARGV)
      parse_options(argv)
      # Load the config file if it's present
      filename = File.expand_path(config[:config_file])
      MarkdownLint::Config.from_file(filename) if File.exists?(filename)

      # Put values in the config file
      MarkdownLint::Config.merge!(config)

      # Set the correct format for any rules/tags configuration loaded from
      # the config file. Ideally this would probably be done as part of the
      # config class itself rather than here.
      MarkdownLint::Config[:rules] = CLI.toggle_list(
        MarkdownLint::Config[:rules]) unless MarkdownLint::Config[:rules].nil?
      MarkdownLint::Config[:tags] = CLI.toggle_list(
        MarkdownLint::Config[:tags], true) \
        unless MarkdownLint::Config[:tags].nil?

      # Read from stdin if we didn't provide a filename
      if cli_arguments.empty? and not config[:list_rules]
        cli_arguments << "-"
      end
    end

    def self.toggle_list(parts, to_sym=false)
      if parts.class == String
        parts = parts.split(',')
      end
      inc = parts.select{|p| not p.start_with?('~')}
      exc = parts.select{|p| p.start_with?('~')}.map{|p| p[1..-1]}
      if to_sym
        inc.map!{|p| p.to_sym}
        exc.map!{|p| p.to_sym}
      end
      {:include => inc, :exclude => exc}
    end
  end
end
