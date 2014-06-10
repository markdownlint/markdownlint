module MarkdownLint
  class Rule
    attr_accessor :id, :description, :check, :tags

    def initialize(id, description)
      @id, @description = id, description
      @tags = []
    end
  end

  class RuleSet
    attr_reader :rules

    def rule(id, description, &block)
      @rules = {} if @rules.nil?
      @rules[id] = Rule.new(id, description)
      @last_rule = id
      yield self
    end

    def check(&block)
      @rules[@last_rule].check = block
    end

    def tags(*t)
      @rules[@last_rule].tags = t.flatten.map {|i| i.to_sym}
    end

    def self.load_default
      self.load(File.expand_path("../rules.rb", __FILE__))
    end

    def self.load(rules_file)
      ruleset = new
      ruleset.instance_eval(File.read(rules_file), rules_file)
      ruleset.rules
    end
  end
end
