rule "MD001", "Header levels should only increment by one level at a time" do
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
  check do |doc|
    first_header = doc.find_type(:header).first
    [first_header[:location]] unless first_header[:level] == 1
  end
end

rule "MD003", "Mixed header styles" do
  # Header styles are things like ### and adding underscores
  # See http://daringfireball.net/projects/markdown/syntax#header
  check do |doc|
    headers = doc.find_type_elements(:header)
    doc_style = doc.header_style(headers.first)
    headers.map { |h| doc.element_linenumber(h) \
                  if doc.header_style(h) != doc_style }.compact
  end
end
