# Modified version of the kramdown parser to add in features/changes
# appropriate for markdownlint, but which don't make sense to try to put
# upstream.
require 'kramdown/parser/gfm'

module Kramdown
  module Parser
    class MarkdownLint < Kramdown::Parser::Kramdown

      def initialize(source, options)
        super
        i = @block_parsers.index(:codeblock_fenced)
        @block_parsers.delete(:codeblock_fenced)
        @block_parsers.insert(i, :codeblock_fenced_gfm)
      end

      # Add location information to text elements
      def add_text(text, tree = @tree, type = @text_type)
        super
        if tree.children.last
          tree.children.last.options[:location] = @src.current_line_number
        end
      end

      # Regular kramdown parser, but with GFM style fenced code blocks
      FENCED_CODEBLOCK_MATCH = Kramdown::Parser::GFM::FENCED_CODEBLOCK_MATCH
    end
  end
end
