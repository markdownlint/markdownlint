# Rules

This document contains a description of all rules, what they are checking for,
as well as an examples of documents that break the rule and corrected
versions of the examples.

## MD001 - Header levels should only increment by one level at a time

Tags: headers

This rule is triggered when you skip header levels in a markdown document, for
example:

    # Header 1

    ### Header 3

    We skipped out a 2nd level header in this document

When using multiple header levels, nested headers should increase by only one
level at a time:

    # Header 1

    ## Header 2

    ### Header 3

    #### Header 4

    ## Another Header 2

    ### Another Header 3


## MD002 - First header should be a top level header

Tags: headers

This rule is triggered when the first header in the document isn't a h1 header:

    ## This isn't a H1 header

    ### Another header

The first header in the document should be a h1 header:

    # Start with a H1 header

    ## Then use a H2 for subsections

## MD003 - Mixed header styles

Tags: headers, mixed

This rule is triggered when different header styles (atx, setext, and 'closed'
atx) are used in the same document:

    # ATX style H1

    ## Closed ATX style H2 ##

    Setext style H1
    ===============

Be consistent with the style of header used in a document:

    # ATX style H1

    ## ATX style H2

## MD004 - Mixed bullet styles

Tags: bullet, mixed

This rule is triggered when different symbols are used in the same document
for unordered list items:

    * Item 1
    + Item 2
    - Item 3

Use the same symbol for list items throughout the document:

    * Item 1
    * Item 2
    * Item 3

## MD005 - Inconsistent indentation for bullets at the same level

Tags: bullet, indentation

This rule is triggered when list items are parsed as being at the same level,
but don't have the same indentation:

    * Item 1
        * Nested Item 1
        * Nested Item 2
       * A misaligned item

Usually this rule will be triggered because of a typo. Correct the indentation
for the list to fix it:

    * Item 1
      * Nested Item 1
      * Nested Item 2
      * Nested Item 3

## MD006 - Consider starting bulleted lists at the beginning of the line

Tags: bullet, indentation

This rule is triggered when top level lists don't start at the beginning of a
line:

    Some text

      * List item
      * List item

To fix, ensure that top level list items are not indented:


    Some test

    * List item
    * List item

Rationale: Starting lists at the beginning of the line means that nested list
items can all be indented by the same amount when an editor's indent function
or the tab key is used to indent. Starting a list 1 space in means that the
indent of the first nested list is less than the indent of the second level (3
characters if you use 4 space tabs, or 1 character if you use 2 space tabs).

## MD007 - Bullets must be indented by 4 spaces in multi-markdown

Tags: bullet, multimarkdown

This rule is triggered when list items are not indented by 4 spaces. This is a
compatibility issue with multi-markdown parsers, which require a 4 space
indents. See
http://support.markedapp.com/discussions/problems/21-sub-lists-not-indenting
for a description of the problem.

Example:

    * List item
      * Nested list item - this would be rendered as the same list item in
        multi-markdown.

Corrected Example:

    * List item
        * Nested list item

This rule is not enabled by default, and you do not have to enable it unless
you need to be compatible with the multi-markdown parser.

## MD008 - Consider 2 space indents for bulleted lists

Tags: bullet, not)multimarkdown

This rule is triggered when list items are not indented by 2 spaces.

Example:

    * List item
       * Nested list item indented by 3 spaces

Corrected Example:

    * List item
      * Nested list item indented by 2 spaces

Rationale: indending by 2 spaces allows the content of a nested list to be in
line with the start of the content of the parent list.

## MD009 - Trailing spaces

Tags: whitespace

This rule is triggered on any lines that end with whitespace. To fix this,
find the line that is triggered and remove any trailing spaces from the end.

## MD010 - Hard tabs

Tags: whitespace, hard_tab

This rule is triggered any any lines that contain hard tab characters instead
of using spaces for indentation. To fix this, replace any hard tab characters
with spaces instead.

Example:

    Some text

    	* hard tab character used to indent the list item

Corrected example:

    Some text

        * Spaces used to indent the list item instead

## MD011 - Reversed link syntax

Tags: links

This rule is triggered when text that appears to be a link is encountered, but
where the syntax appears to have been reversed (the `[]` and `()` are
reversed):

    (Incorrect link syntax)[http://www.example.com/]

To fix this, swap the `[]` and `()` around:

    [Correct link syntax](http://www.example.com/)

## MD012 - Multiple consecutive blank lines

Tags: whitespace, blank_lines

This rule is triggered when there are multiple consecutive blank lines in the
document:

    Some text here


    Some more text here

To fix this, delete the offending lines:

    Some text here

    Some more text here

Note: this rule will not be triggered if there are multiple consecutive blank
lines inside code blocks.

## MD013 - Line longer than 80 character

Tags: line_length

This rule is triggered when there are lines that are longer than 80
characters. To fix this, split the line up into multiple lines.

This rule has an exception where there is no whitespace after the 80th
character. This allows you to still include items such as long URLs without
being forced to break them in the middle.

## MD014 - Dollar signs used before commands without showing output

Tags: code

This rule is triggered when there are code blocks showing shell commands to be
typed, and the shell commands are preceded by dollar signs ($):

    $ ls
    $ cat foo
    $ less bar

The dollar signs are unnecessary in the above situation, and should not be
included:

    ls
    cat foo
    less bar

However, an exception is made when there is a need to distinguish between
typed commands and command output, as in the following example:

    $ ls
    foo bar
    $ cat foo
    Hello world
    $ cat bar
    baz

Rationale: it is easier to copy and paste and less noisy if the dollar signs
are omitted when they are not needed. See
<http://www.cirosantilli.com/markdown-styleguide/#dollar-signs-in-shell-code>
for more information.

## MD015 - Use of non-atx style headers

Tags: headers, atx, specific_style

This rule enforces a specific header style to be used in a document (in this
case, atx style headers). Use of other header styles will trigger the rule. If
you enable one of the header style rules, you should pick only one of them.
Alternatively, just enable MD003, which will enforce consistent header styles
within a document.

Example of ATX style headers:

    # Header 1

    ## Header 2

## MD016 - Use of non-closed-atx style headers

Tags: headers, atx_closed, specific_style

This rule enforces a specific header style to be used in a document (in this
case, closed atx style headers). Use of other header styles will trigger the
rule. If you enable one of the header style rules, you should pick only one of
them.  Alternatively, just enable MD003, which will enforce consistent header
styles within a document.

Example of closed atx style headers:

    # Header 1 #

    ## Header 2 ##

## MD017 - Use of non-setext style headers

Tags: headers, setext, specific_style

This rule enforces a specific header style to be used in a document (in this
case, setext style headers). Use of other header styles will trigger the
rule. If you enable one of the header style rules, you should pick only one of
them.  Alternatively, just enable MD003, which will enforce consistent header
styles within a document.

Example of setext style headers:

    Header 1
    ========

    Header 2
    --------

## MD018 - No space after hash on atx style header

Tags: headers, atx, spaces

This rule is triggered when when spaces are missing after the hash characters
in an atx style header:

    #Header 1

    ##Header 2

To fix this, separate the header text from the hash character by a single
space:

    # Header 1

    ## Header 2

## MD019 - Multiple spaces after hash on atx style header

Tags: headers, atx, spaces

This rule is triggered when when more than one space is used to separate the
header text from the hash characters in an atx style header:

    #  Header 1

    ##  Header 2

To fix this, separate the header text from the hash character by a single
space:

    # Header 1

    ## Header 2

## MD020 - No space inside hashes on closed atx style header

Tags: headers, atx_closed, spaces

This rule is triggered when when spaces are missing inside the hash characters
in a closed atx style header:

    #Header 1#

    ##Header 2##

To fix this, separate the header text from the hash character by a single
space:

    # Header 1 #

    ## Header 2 ##

Note: this rule will fire if either side of the header is missing spaces.

## MD021 - Multiple spaces inside hashes on closed atx style header

Tags: headers, atx_closed, spaces

This rule is triggered when when more than one space is used to separate the
header text from the hash characters in a closed atx style header:

    #  Header 1  #

    ##  Header 2  ##

To fix this, separate the header text from the hash character by a single
space:

    # Header 1 #

    ## Header 2 ##

Note: this rule will fire if either side of the header contains multiple
spaces.

## MD022 - Headers should be surrounded by blank lines

Tags: headers, blank_lines

This rule is triggered when headers (any style) are either not preceded or not
followed by a blank line:

    # Header 1
    Some text

    Some more text
    ## Header 2

To fix this, ensure that all headers have a blank line both before and after
(except where the header is at the beginning or end of the document):

    # Header 1

    Some text

    Some more text

    ## Header 2

Rationale: Aside from asthetic reasons, some parsers, including kramdown, will
not parse headers that don't have a blank line before, and will parse them as
regular text.

## MD023 - Headers must start at the beginning of the line

Tags: headers, spaces

This rule is triggered when a header is indented by one or more spaces:

    Some text

      # Indented header

To fix this, ensure that all headers start at the beginning of the line:

    Some text

    # Header

Rationale: Headers that don't start at the beginning of the line will not be
parsed as headers, and will instead appear as regular text.
