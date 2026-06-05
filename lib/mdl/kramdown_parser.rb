# Modified version of the kramdown parser to add in features/changes
# appropriate for markdownlint, but which don't make sense to try to put
# upstream.
require 'kramdown/parser/gfm'

module Kramdown
  module Parser
    # modified parser class - see comment above
    class MarkdownLint < Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        i = @block_parsers.index(:codeblock_fenced)
        @block_parsers.delete(:codeblock_fenced)
        @block_parsers.insert(i, :codeblock_fenced_gfm)
      end

      # GFM fenced code blocks, extended to allow spaces in the info string
      # (e.g. ```c hlines=2). The GFM regex restricts the info string to a
      # single non-whitespace token, which causes kramdown to miss blocks whose
      # info string contains a space, leading to false positives inside them.
      # Capture groups match GFM's: 1=fence, 2=fence-char, 3=full-info,
      # 4=first-word, 5=content.
      FENCED_CODEBLOCK_MATCH =
        /^ {0,3}(([~`]){3,})\s*?((\S+?)[^\n]*)?\n(.*?)^ {0,3}\1\2*\s*?\n/m

      # End paragraphs when a fenced code block starts, matching GFM
      # behavior. Without this, fenced code blocks without a preceding
      # blank line are swallowed into the paragraph.
      PARAGRAPH_END = Regexp.union(
        Kramdown::Parser::Kramdown::PARAGRAPH_END,
        Kramdown::Parser::GFM::FENCED_CODEBLOCK_START,
      )
    end
  end
end
