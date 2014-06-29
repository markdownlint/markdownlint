[![Stories in Ready](https://badge.waffle.io/mivok/markdownlint.png?label=ready&title=Ready)](https://waffle.io/mivok/markdownlint)
# Markdown lint tool

A simple tool to lint markdown files and flag style issues.

## Creating Rules

    rule "MD000", "Rule name" do
      check do |doc|
        # check code goes here
        # return a list of line numbers that break the rule, or an empty list
        # (or nil) if there are no problems.
      end
    end

* doc - Object containing a representation of the markdown document
* doc.lines - The raw markdown file as an array of lines
  * You can look up a line given an element with doc.element_lines
* doc.parsed - Kramdown internal representation of the doc
* doc.elements - All elements in the doc
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
