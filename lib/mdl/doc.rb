require 'kramdown'

module MarkdownLint
  # Representation of the markdown document passed to rule checks
  class Doc
    attr_reader :lines, :parsed, :elements

    def initialize(text)
      @lines = text.split("\n")
      @parsed = Kramdown::Document.new(text)
      @elements = @parsed.root.children
    end

    def self.new_from_file(filename)
      # Alternate 'constructor' passing in a filename
      self.new(File.read(filename))
    end

    def find_type(type)
      find_type_elements(type).map { |e| e.options }
    end

    def find_type_elements(type, elements=@elements)
      results = []
      elements.each do |e|
        results.push(e) if e.type == type
        if not e.children.empty?
          results.concat(find_type_elements(type, e.children))
        end
      end
      results
    end

    def element_linenumber(element)
      element = element.options if element.is_a?(Kramdown::Element)
      element[:location]
    end

    def element_line(element)
      @lines[element_linenumber(element) - 1]
    end

    def element_linenumbers(elements)
      elements.map { |e| element_linenumber(e) }
    end

    def element_lines(elements)
      # Gets the raw text lines where elements are located
      elements.map { |e| element_line(e) }
    end

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
  end
end
