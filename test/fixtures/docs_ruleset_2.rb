require 'digest/md5'

docs do |id, description|
  "https://example.com/#{id}##{Digest::MD5.hexdigest(description)}"
end

rule 'MY004', 'Documents must start with C' do
  tags :opinionated
  check do |doc|
    [1] if doc.lines[0] != 'C'
  end
end

rule 'MY005', 'Documents must start with D' do
  tags :opinionated
  docs 'https://example.com/override-docs'
  check do |doc|
    [1] if doc.lines[0] != 'D'
  end
end

rule 'MY007', 'Documents must start with F' do
  tags :opinionated

  docs do |id, description|
    hash = description.downcase.gsub(/[^a-z]+/, '-')
    "https://example.com/dynamic-override/#{id}##{hash}"
  end

  check do |doc|
    [1] if doc.lines[0] != 'F'
  end
end

docs 'https://example.com/later-declaration'

rule 'MY006', 'Documents must start with E' do
  tags :opinionated
  check do |doc|
    [1] if doc.lines[0] != 'E'
  end
end
