require 'set'

module MarkdownLint
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

    def rule(id, params={})
      id = @aliases[id] if @aliases[id]
      @rules << id
      @all_rules[id].params(params)
    end

    def exclude_rule(id)
      id = @aliases[id] if @aliases[id]
      @rules.delete(id)
    end

    def tag(t)
      @rules.merge(@tagged_rules[t])
    end

    def exclude_tag(t)
      @rules.subtract(@tagged_rules[t])
    end

    def self.load(style_file, rules)
      unless style_file.include?("/") or style_file.end_with?(".rb")
        style_file = File.expand_path("../styles/#{style_file}.rb", __FILE__)
      end
      style = new(rules)
      style.instance_eval(File.read(style_file), style_file)
      rules.select! {|r| style.rules.include?(r)}
      style
    end
  end
end
