module MarkdownLint
  class Rule
    attr_accessor :id, :description

    def initialize(id, description, block)
      @id, @description = id, description
      @tags = []
      @params = {}
      instance_eval &block
    end


    def check(&block)
      @check = block unless block.nil?
      @check
    end

    def tags(*t)
      @tags = t.flatten.map {|i| i.to_sym} unless t.empty?
      @tags
    end

    def params(p = nil)
      @params.update(p) unless p.nil?
      @params
    end
  end

  class RuleSet
    attr_reader :rules

    def rule(id, description, &block)
      @rules = {} if @rules.nil?
      @rules[id] = Rule.new(id, description, block)
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
