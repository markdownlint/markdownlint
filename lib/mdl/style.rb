require 'set'

module MarkdownLint
  class Style
    attr_reader :rules

    def initialize(all_rules)
      @tagged_rules = {}
      all_rules.each do |id, r|
        r.tags.each do |t|
          @tagged_rules[t] ||= Set.new
          @tagged_rules[t] << id
        end
      end
      @all_rules = Set.new(all_rules.keys)
      @rules = Set.new
    end

    def all
      @rules.merge(@all_rules)
    end

    def rule(id)
      @rules << id
    end

    def exclude_rule(id)
      @rules.delete(id)
    end

    def tag(t)
      @rules.merge(@tagged_rules[t])
    end

    def exclude_tag(t)
      @rules.subtract(@tagged_rules[t])
    end

    def self.load(style_file, all_rules)
      style = new(all_rules)
      style.instance_eval(File.read(style_file), style_file)
      style
    end
  end
end
