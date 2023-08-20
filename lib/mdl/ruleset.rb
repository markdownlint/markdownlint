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

    # This method calculates the number of columns in a table row
    #
    # @param [String] table_row A row of the table in question.
    # @return [Numeric] Number of columns in the row
    def number_of_columns_in_a_table_row(table_row)
      columns = table_row.strip.split('|')

      if columns.empty?
        # The stripped line consists of zero or more pipe characters
        # and nothing more.
        #
        # Examples of stripped rows:
        #   '||' --> one column
        #   '|||' --> two columns
        #   '|' --> zero columns
        [0, table_row.count('|') - 1].max
      else
        # Number of columns is the number of splited
        # segments with pipe separator. The first segment
        # is ignored when it's empty string because
        # someting like '|1|2|' is split into ['', '1', '2']
        # when using split('|') function.
        #
        # Some examples:
        #   '|foo|bar|' --> two columns
        #   '  |foo|bar|' --> two columns
        #   '|foo|bar' --> two columns
        #   'foo|bar' --> two columns
        columns.size - (columns[0].empty? ? 1 : 0)
      end
    end

    # This method returns all the rows of a table
    #
    # @param [Array<String>] lines Lines of a doc as an array
    # @param [Numeric] pos Position/index of the table in the array
    # @return [Array<String>] Rows of the table in an array
    def get_table_rows(lines, pos)
      table_rows = []
      while pos < lines.length
        line = lines[pos]

        # If the previous line is a table and the current line
        #   1) includes pipe character
        #   2) does not start with code block identifiers
        #     a) >= 4 spaces
        #     b) < 4 spaces and ``` right after
        #
        # it is possibly a table row
        unless line.include?('|') && !line.start_with?('    ') &&
               !line.strip.start_with?('```')
          break
        end

        table_rows << line
        pos += 1
      end

      table_rows
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
