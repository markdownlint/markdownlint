module MarkdownLint
  class Rule
    attr_accessor :id, :description

    def initialize(id, description, block)
      @id, @description = id, description
      @aliases = []
      @tags = []
      @params = {}
      instance_eval(&block)
    end


    def check(&block)
      @check = block unless block.nil?
      @check
    end

    def tags(*t)
      @tags = t.flatten.map {|i| i.to_sym} unless t.empty?
      @tags
    end

    def aliases(*a)
      @aliases.concat(a)
      @aliases
    end

    def params(p = nil)
      @params.update(p) unless p.nil?
      @params
    end

  end

  class RuleSet
    attr_reader :rules

    def initialize
      @rules = {}
    end

    def rule(id, description, &block)
      @rules[id] = Rule.new(id, description, block)
    end

    def load(rules_file)
      instance_eval(File.read(rules_file), rules_file)
      @rules
    end

    def load_default
      load(File.expand_path("../rules.rb", __FILE__))
    end
  end
end
