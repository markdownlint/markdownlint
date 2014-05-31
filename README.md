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

## TODO

* Helpers for:
  * getting the raw line given an element
  * populating errors given a set of elements (i.e. turn a list of elements
    into line numbers)
* Xpath lookup for kramdown elements (see if xpath module is available and
  generic - see foodcritic for an example)
