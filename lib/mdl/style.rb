require 'set'

module MarkdownLint
  # defines a style
  class Style
    attr_reader :rules

    def initialize(all_rules)
      @tagged_rules = {}
      @aliases = {}
      all_rules.each do |id, r|
        r.tags.each do |t|
          @tagged_rules[t] ||= Set.new
          @tagged_rules[t] << id
        end
        r.aliases.each do |a|
          @aliases[a] = id
        end
      end
      @all_rules = all_rules
      @rules = Set.new
    end

    def all
      @rules.merge(@all_rules.keys)
    end

    def rule(id, params = {})
      if block_given?
        raise '"rule" does not take a block. Should this definition go in a ' +
              'ruleset instead?'
      end

      id = @aliases[id] if @aliases[id]
      raise "No such rule: #{id}" unless @all_rules[id]

      @rules << id
      @all_rules[id].params(params)
    end

    def exclude_rule(id)
      id = @aliases[id] if @aliases[id]
      @rules.delete(id)
    end

    def tag(tag)
      @rules.merge(@tagged_rules[tag])
    end

    def exclude_tag(tag)
      @rules.subtract(@tagged_rules[tag])
    end

    def self.load(style_file, rules)
      unless style_file.include?('/') || style_file.end_with?('.rb')
        tmp = File.expand_path("../styles/#{style_file}.rb", __FILE__)
        unless File.exist?(tmp)
          warn "#{style_file} does not appear to be a built-in style." +
               ' If you meant to pass in your own style file, it must contain' +
               " a '/' or end in '.rb'. See https://github.com/markdownlint/" +
               'markdownlint/blob/main/docs/configuration.md'
          exit(1)
        end
        style_file = tmp
      end

      unless File.exist?(style_file)
        warn "Style '#{style_file}' does not exist."
        exit(1)
      end

      style = new(rules)
      style.instance_eval(File.read(style_file), style_file)
      rules.select! { |r| style.rules.include?(r) }
      style
    end
  end
end
