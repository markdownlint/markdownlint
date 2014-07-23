require 'mixlib/cli'

module MarkdownLint
  class CLI
    include Mixlib::CLI

    banner "Usage: #{File.basename($0)} [options] FILE.md [FILE.md ...]"

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
      :proc => Proc.new { |v| v.split(',').map { |t| t.to_sym } }

    option :rules,
      :short => '-r',
      :long => '--rules RULE1,RULE2',
      :description => 'Only process these rules',
      :proc => Proc.new { |v| v.split(',') }

    option :style,
      :short => '-s',
      :long => '--style STYLE',
      :description => "Load the given style"

    option :list_rules,
      :short => '-l',
      :long => '--list-rules',
      :boolean => true,
      :description => "Don't process any files, just list enabled rules"

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

      # We need at least one non-option argument
      if cli_arguments.empty? and not config[:list_rules]
        puts opt_parser
        exit -1
      end
    end
  end
end
