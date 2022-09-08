module MarkdownLint
  # defines a single rule
  class Rule
    attr_accessor :id, :description

    def initialize(id, description, fallback_docs: nil, &block)
      @id = id
      @description = description
      @generate_docs = fallback_docs
      @docs_overridden = false
      @aliases = []
      @tags = []
      @params = {}
      instance_eval(&block)
    end

    def check(&block)
      @check = block unless block.nil?
      @check
    end

    def tags(*tags)
      @tags = tags.flatten.map(&:to_sym) unless tags.empty?
      @tags
    end

    def aliases(*aliases)
      @aliases.concat(aliases)
      @aliases
    end

    def params(params = nil)
      @params.update(params) unless params.nil?
      @params
    end

    def docs(url = nil, &block)
      if block_given? != url.nil?
        raise ArgumentError, 'Give either a URL or a block, not both'
      end

      raise 'A docs url is already set within this rule' if @docs_overridden

      @generate_docs = block_given? ? block : lambda { |_, _| url }
      @docs_overridden = true
    end

    def docs_url
      @generate_docs&.call(id, description)
    end
  end

  # defines a ruleset
  class RuleSet
    attr_reader :rules

    def initialize
      @rules = {}
    end

    def rule(id, description, &block)
      @rules[id] =
        Rule.new(id, description, :fallback_docs => @fallback_docs, &block)
    end

    def load(rules_file)
      instance_eval(File.read(rules_file), rules_file)
      @rules
    end

    def docs(url = nil, &block)
      if block_given? != url.nil?
        raise ArgumentError, 'Give either a URL or a block, not both'
      end

      @fallback_docs = block_given? ? block : lambda { |_, _| url }
    end

    def load_default
      load(File.expand_path('rules.rb', __dir__))
    end
  end
end
