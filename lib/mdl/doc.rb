require 'kramdown'
require 'mdl/kramdown_parser'

module MarkdownLint
  ##
  # Representation of the markdown document passed to rule checks

  class Doc
    ##
    # A list of raw markdown source lines. Note that the list is 0-indexed,
    # while line numbers in the parsed source are 1-indexed, so you need to
    # subtract 1 from a line number to get the correct line. The element_line*
    # methods take care of this for you.

    attr_reader :lines

    ##
    # A Kramdown::Document object containing the parsed markdown document.

    attr_reader :parsed

    ##
    # A list of top level Kramdown::Element objects from the parsed document.

    attr_reader :elements

    ##
    # Create a new document given a string containing the markdown source

    def initialize(text)
      @lines = text.split("\n")
      @parsed = Kramdown::Document.new(text, :input => 'MarkdownLint')
      @elements = @parsed.root.children
      add_levels(@elements)
    end

    ##
    # Alternate 'constructor' passing in a filename

    def self.new_from_file(filename)
      if filename == "-"
        self.new(STDIN.read)
      else
        self.new(File.read(filename))
      end
    end

    ##
    # Find all elements of a given type, returning their options hash. The
    # options hash has most of the useful data about an element and often you
    # can just use this in your rules.
    #
    #   # Returns [ { :location => 1, :element_level => 2 }, ... ]
    #   elements = find_type(:li)
    #
    # If +nested+ is set to false, this returns only top level elements of a
    # given type.

    def find_type(type, nested=true)
      find_type_elements(type, nested).map { |e| e.options }
    end

    ##
    # Find all elements of a given type, returning a list of the element
    # objects themselves.
    #
    # Instead of a single type, a list of types can be provided instead to
    # find all types.
    #
    # If +nested+ is set to false, this returns only top level elements of a
    # given type.

    def find_type_elements(type, nested=true, elements=@elements)
      results = []
      if type.class == Symbol
        type = [type]
      end
      elements.each do |e|
        results.push(e) if type.include?(e.type)
        if nested and not e.children.empty?
          results.concat(find_type_elements(type, nested, e.children))
        end
      end
      results
    end

    ##
    # A variation on find_type_elements that allows you to skip drilling down
    # into children of specific element types.
    #
    # Instead of a single type, a list of types can be provided instead to
    # find all types.
    #
    # Unlike find_type_elements, this method will always search for nested
    # elements, and skip the element types given to nested_except.

    def find_type_elements_except(type, nested_except=[], elements=@elements)
      results = []
      if type.class == Symbol
        type = [type]
      end
      if nested_except.class == Symbol
        nested_except = [nested_except]
      end
      elements.each do |e|
        results.push(e) if type.include?(e.type)
        unless nested_except.include?(e.type) or e.children.empty?
          results.concat(find_type_elements_except(type, nested_except, e.children))
        end
      end
      results
    end

    ##
    # Returns the line number a given element is located on in the source
    # file. You can pass in either an element object or an options hash here.

    def element_linenumber(element)
      element = element.options if element.is_a?(Kramdown::Element)
      element[:location]
    end

    ##
    # Returns the actual source line for a given element. You can pass in an
    # element object or an options hash here. This is useful if you need to
    # examine the source line directly for your rule to make use of
    # information that isn't present in the parsed document.

    def element_line(element)
      @lines[element_linenumber(element) - 1]
    end

    ##
    # Returns a list of line numbers for all elements passed in. You can pass
    # in a list of element objects or a list of options hashes here.

    def element_linenumbers(elements)
      elements.map { |e| element_linenumber(e) }
    end

    ##
    # Returns the actual source lines for a list of elements. You can pass in
    # a list of elements objects or a list of options hashes here.

    def element_lines(elements)
      elements.map { |e| element_line(e) }
    end

    ##
    # Returns the header 'style' - :atx (hashes at the beginning), :atx_closed
    # (atx header style, but with hashes at the end of the line also), :setext
    # (underlined). You can pass in the element object or an options hash
    # here.

    def header_style(header)
      if header.type != :header
        raise "header_style called with non-header element"
      end
      line = element_line(header)
      if line.start_with?("#")
        if line.strip.end_with?("#")
          :atx_closed
        else
          :atx
        end
      else
        :setext
      end
    end

    ##
    # Returns the list style for a list: :asterisk, :plus, :dash, :ordered or
    # :ordered_paren depending on which symbol is used to denote the list
    # item. You can pass in either the element itself or an options hash here.

    def list_style(item)
      if item.type != :li
        raise "list_style called with non-list element"
      end
      line = element_line(item).strip
      if line.start_with?('*')
        :asterisk
      elsif line.start_with?('+')
        :plus
      elsif line.start_with?('-')
        :dash
      elsif line.match('[0-9]+\.')
        :ordered
      elsif line.match('[0-9]+\)')
        :ordered_paren
      else
        :unknown
      end
    end

    ##
    # Returns how much a given line is indented. Hard tabs are treated as an
    # indent of 8 spaces. You need to pass in the raw string here.

    def indent_for(line)
      return line.match(/^\s*/)[0].gsub("\t", " " * 8).length
    end

    ##
    # Returns line numbers for lines that match the given regular expression

    def matching_lines(re)
      @lines.each_with_index.select{|text, linenum| re.match(text)}.map{
        |i| i[1]+1}
    end

    ##
    # Returns line numbers for lines that match the given regular expression.
    # Only considers text inside of 'text' elements (i.e. regular markdown
    # text and not code/links or other elements).
    def matching_text_element_lines(re, exclude_nested=[:a])
      matches = []
      find_type_elements_except(:text, exclude_nested).each do |e|
        first_line = e.options[:location]
        lines = e.value.split("\n")
        lines.each_with_index do |l, i|
          matches << first_line + i if re.match(l)
        end
      end
      matches
    end

    ##
    # Extracts the text from an element whose children consist of text
    # elements and other things

    def extract_text(element, prefix="")
      quotes = {
        :rdquo => '"',
        :ldquo => '"',
        :lsquo => "'",
        :rsquo => "'"
      }
      # If anything goes amiss here, e.g. unknown type, then nil will be
      # returned and we'll just not catch that part of the text, which seems
      # like a sensible failure mode.
      lines = element.children.map { |e|
        if e.type == :text
          e.value
        elsif [:strong, :em, :p].include?(e.type)
          extract_text(e, prefix).join("\n")
        elsif e.type == :smart_quote
          quotes[e.value]
        end
      }.join.split("\n")
      # Text blocks have whitespace stripped, so we need to add it back in at
      # the beginning. Because this might be in something like a blockquote,
      # we optionally strip off a prefix given to the function.
      lines[0] = element_line(element).sub(prefix, "")
      lines
    end

    private

    ##
    # Adds a 'level' option to all elements to show how nested they are

    def add_levels(elements, level=1)
      elements.each do |e|
        e.options[:element_level] = level
        add_levels(e.children, level+1)
      end
    end

  end
end
