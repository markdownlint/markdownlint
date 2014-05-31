rule "MD001", "Header levels should only increment by one level at a time" do
  check do |doc, lines|
    headers = doc.root.children.map{ |e| e.options if e.type == :header }.compact
    old_level = nil
    errors = []
    headers.each do |h|
      if old_level and h[:level] > old_level + 1
        errors << h[:location]
      end
      old_level = h[:level]
    end
    errors
  end
end

rule "MD002", "First header should be a top level header" do
  check do |doc, lines|
    first_header = doc.root.children.select { |e| e.type == :header }.first.options
    [first_header[:location]] unless first_header[:level] == 1
  end
end

rule "MD003", "Mixed header styles" do
  # Header styles are things like ### and adding underscores
  # See http://daringfireball.net/projects/markdown/syntax#header
  check do |doc, lines|
    doc_style = nil
    errors = []
    doc.root.children.select { |e| e.type == :header }.each do |h|
      line = lines[h.options[:location] - 1]
      if line.start_with?("#")
        if line.strip.end_with?("#")
          style = :atx_closed
        else
          style = :atx
        end
      else
        style = :setext
      end
      doc_style = style if doc_style.nil?
      if style != doc_style
        errors << h.options[:location]
      end
    end
    errors
  end
end
