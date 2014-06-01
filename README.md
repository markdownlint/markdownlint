# Rules

    rule "MD000", "Rule name" do
      check do |doc, lines|
        # check code goes here
        # return a list of line numbers that break the rule, or an empty list
        # (or nil) if there are no problems.
      end
    end

* doc - Kramdown internal representation of the parsed document
* lines - The raw markdown file as an array of lines
  * You can look up a line with:
    * `lines[element.options[:location] - 1]` where `element` is a kramdown
      element (location is the line number where the element was parsed)
* doc.root.children - all elements in the doc
* element.options - hash containing:
  * `:type` - symbol describing the type of element
  * `:location` - line number of element
  * other stuff that varies by element

## Contributing

1. Fork it ( http://github.com/mivok/mdl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
