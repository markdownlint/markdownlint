rule "MY001", "Documents must start with Hello World" do
  tags :opinionated
  check do |doc|
    [1] if doc.lines[0] != "Hello World"
  end
end
