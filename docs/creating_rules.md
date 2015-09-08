# Creating Rules

Rules are written in ruby, using a rule DSL for defining rules. A rule looks
like:

    rule "MD000", "Rule description" do
      tags :foo, :bar
      aliases 'rule-name'
      params :style => :foo
      check do |doc|
        # check code goes here
        # return a list of line numbers that break the rule, or an empty list
        # (or nil) if there are no problems.
      end
    end

The first line specifies the rule name and description. By convention, built
in markdownlint rules use the prefix 'MD' followed by a number to identify
rules. Any custom rules should use an alternate prefix to avoid conflicting
with current or future rules. The description is simply a short description
explaining what the rule is checking, which will be printed alongside the rule
name when rules are triggered.

Next, the rule's tags are specified. These are simply ruby symbols, and can be
used by a user to limit which rules are checks. For example, if your rule
checks whitespace usage in a document, you can add the `:whitespace` tag, and
users who don't care about whitespace can exclude that tag on the command line
or in style files.

You can also specify aliases for the rule, which can be used to refer to the
rule with a human-readable name rather than MD000. To do this, add then with
the 'aliases' directive. Whenever you refer to a rule, such as for
including/excluding in the configuration or in style files, you can use an
alias for the rule instead of its ID.

After that, any parameters the rule takes are specified. If your rule checks
for a specific number of things, or if you can envision multiple variants of
the same rule, then you should add parameters to allow your rule to be
customized in a style file. Any parameters specified here are accessible
inside the check itself using `params[:foo]`.

Finally, the check itself is specified. This is simply a ruby block that
should return a list of line numbers for any issues found. If no line numbers
are found, you can either return an empty list, or nil, whichever is easiest
for your check.

## Document objects

The check takes a single parameter `'doc'`, which is an object containing a
representation of the markdown document along with several helper functions
used for making rules. The [doc.rb](../lib/mdl/doc.rb) file is documented
using rdoc, and you will want to take a look there to see all the methods you
can use, as well as look at some of the existing rules, but a quick summary is
as follows:

* `doc` - Object containing a representation of the markdown document
* `doc.lines` - The raw markdown file as an array of lines
  * You can also look up a line given an element with
    `doc.element_line(element)`
* `doc.parsed` - The kramdown internal representation of the doc. Most of the
  time you will want to interact with the parsed version of the document
  rather than looking at `doc.lines`.
* `doc.find_type_elements` - A method to find all elements of a given type.
  You pass the type as a symbol, such as `:ul` or `:p`. Most element types
  match the name of the element in HTML output. This method returns a list of
  the matching elements.
* `doc.find_type` - This is like `doc.find_type_elements`, but returns just
  the options hashes (see below) for each element. This is useful if you don't
  need all the element information, but you do need the line numbers.
* `doc.element_line_number` - Pass in an element (or an options hash), and
  this will return the line number for the element. You need to return the
  line number in the list of errors.

## Element objects

The document contains an internal representation of the markdown document as
parsed by kramdown. Kramdown's representation of the document is as a tree of
'element' objects. The following is a quick summary of those objects:

* element.type - a symbol denoting the type of the element, such as `:li`,
  `:p`, `:text`
* element.value - the value of the element. Note that most block level
  elements such as paragraphs don't have any value themselves, but have child
  text elements containing their contents instead.
* element.children - A list of the element's child elements.
* element.options - A hash containing:
  * `:location` - line number of element
  * `:element_level` - A value filled in by markdownlint to denote the nesting
    level of the element, i.e. how deep in the tree is it.
  * Other options that are element type specific.
