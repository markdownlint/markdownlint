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
