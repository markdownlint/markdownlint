require_relative 'spec_helper'

class String
  def unindent
    # Removes indentation from heredoc entries
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

def doc_for(s)
  MarkdownLint::Doc.new(s)
end
