docs 'https://example.com/static-docs'

rule 'MY002', 'Documents must start with A' do
  tags :opinionated
  check do |doc|
    [1] if doc.lines[0] != 'A'
  end
end

rule 'MY003', 'Documents must start with B' do
  tags :opinionated
  docs 'https://example.com/override-docs'
  check do |doc|
    [1] if doc.lines[0] != 'B'
  end
end
