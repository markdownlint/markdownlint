rule "MD001", "Header levels should only increment by one level at a time" do
  tags :headers
  check do |doc|
    headers = doc.find_type(:header)
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
  tags :headers
  check do |doc|
    first_header = doc.find_type(:header).first
    [first_header[:location]] if first_header and first_header[:level] != 1
  end
end

rule "MD003", "Mixed header styles" do
  # Header styles are things like ### and adding underscores
  # See http://daringfireball.net/projects/markdown/syntax#header
  tags :headers, :mixed
  check do |doc|
    headers = doc.find_type_elements(:header)
    if headers.empty?
      nil
    else
      doc_style = doc.header_style(headers.first)
      headers.map { |h| doc.element_linenumber(h) \
                    if doc.header_style(h) != doc_style }.compact
    end
  end
end

rule "MD004", "Mixed bullet styles" do
  tags :bullet, :mixed
  check do |doc|
    bullets = doc.find_type_elements(:li)
    if bullets.empty?
      nil
    else
      doc_style = doc.bullet_style(bullets.first)
      bullets.map { |b| doc.element_linenumber(b) \
                    if doc.bullet_style(b) != doc_style }.compact
    end
  end
end

rule "MD005", "Inconsistent indentation for bullets at the same level" do
  check do |doc|
    bullets = doc.find_type(:li)
    errors = []
    indent_levels = []
    bullets.each do |b|
      indent_level = doc.indent_for(doc.element_line(b))
      if indent_levels[b[:element_level]].nil?
        indent_levels[b[:element_level]] = indent_level
      end
      if indent_level != indent_levels[b[:element_level]]
        errors << doc.element_linenumber(b)
      end
    end
    errors
  end
end

rule "MD006", "Consider starting bulleted lists at the beginning of the line" do
  # Starting at the beginning of the line means that indendation for each
  # bullet level can be identical.
  check do |doc|
    doc.find_type(:ul, false).select{
      |e| doc.indent_for(doc.element_line(e)) != 0 }.map{ |e| e[:location] }
  end
end

rule "MD007", "Bullets must be indented by 4 spaces in multi-markdown" do
  tags :multimarkdown
  check do |doc|
    indents = []
    errors = []
    indents = doc.find_type(:ul).map {
      |e| [doc.indent_for(doc.element_line(e)), doc.element_linenumber(e)] }
    curr_indent = indents[0][0] unless indents.empty?
    indents.each do |indent, linenum|
      if indent > curr_indent and indent - curr_indent != 4
        errors << linenum
      end
      curr_indent = indent
    end
    errors
  end
end

rule "MD008", "Consider 2 space indents for bulleted lists" do
  # If not using multi-markdown, then indents for nested bulleted lists should
  # be 2 spaces. This means that nested lists are in line with the start of
  # the text. This rule is inconsistent with MD007.
  tags :not_multimarkdown
  check do |doc|
    indents = []
    errors = []
    indents = doc.find_type(:ul).map {
      |e| [doc.indent_for(doc.element_line(e)), doc.element_linenumber(e)] }
    curr_indent = indents[0][0] unless indents.empty?
    indents.each do |indent, linenum|
      if indent > curr_indent and indent - curr_indent != 2
        errors << linenum
      end
      curr_indent = indent
    end
    errors
  end
end
