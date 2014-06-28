require 'kramdown'

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
      @parsed = Kramdown::Document.new(text)
      @elements = @parsed.root.children
      add_levels(@elements)
    end

    ##
    # Alternate 'constructor' passing in a filename

    def self.new_from_file(filename)
      self.new(File.read(filename))
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
    # If +nested+ is set to false, this returns only top level elements of a
    # given type.

    def find_type_elements(type, nested=true, elements=@elements)
      results = []
      elements.each do |e|
        results.push(e) if e.type == type
        if nested and not e.children.empty?
          results.concat(find_type_elements(type, nested, e.children))
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
    # Returns the bullet style for an unordered list - :asterisk, :plus,
    # :dash, depending on which symbol is used to denote the list item. You
    # can pass in either the element itself or an options hash here.

    def bullet_style(bullet)
      if bullet.type != :li
        raise "bullet_style called with non-bullet element"
      end
      line = element_line(bullet).strip
      if line.start_with?("*")
        :asterisk
      elsif line.start_with?("+")
        :plus
      elsif line.start_with?("-")
        :dash
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
