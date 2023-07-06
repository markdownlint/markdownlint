
* [Rules](#rules)
   * [MD001 - Header levels should only increment by one level at a time](#md001---header-levels-should-only-increment-by-one-level-at-a-time)
   * [MD002 - First header should be a top level header](#md002---first-header-should-be-a-top-level-header)
   * [MD003 - Header style](#md003---header-style)
   * [MD004 - Unordered list style](#md004---unordered-list-style)
   * [MD005 - Inconsistent indentation for list items at the same level](#md005---inconsistent-indentation-for-list-items-at-the-same-level)
   * [MD006 - Consider starting bulleted lists at the beginning of the line](#md006---consider-starting-bulleted-lists-at-the-beginning-of-the-line)
   * [MD007 - Unordered list indentation](#md007---unordered-list-indentation)
   * [MD009 - Trailing spaces](#md009---trailing-spaces)
   * [MD010 - Hard tabs](#md010---hard-tabs)
   * [MD011 - Reversed link syntax](#md011---reversed-link-syntax)
   * [MD012 - Multiple consecutive blank lines](#md012---multiple-consecutive-blank-lines)
   * [MD013 - Line length](#md013---line-length)
   * [MD014 - Dollar signs used before commands without showing output](#md014---dollar-signs-used-before-commands-without-showing-output)
   * [MD018 - No space after hash on atx style header](#md018---no-space-after-hash-on-atx-style-header)
   * [MD019 - Multiple spaces after hash on atx style header](#md019---multiple-spaces-after-hash-on-atx-style-header)
   * [MD020 - No space inside hashes on closed atx style header](#md020---no-space-inside-hashes-on-closed-atx-style-header)
   * [MD021 - Multiple spaces inside hashes on closed atx style header](#md021---multiple-spaces-inside-hashes-on-closed-atx-style-header)
   * [MD022 - Headers should be surrounded by blank lines](#md022---headers-should-be-surrounded-by-blank-lines)
   * [MD023 - Headers must start at the beginning of the line](#md023---headers-must-start-at-the-beginning-of-the-line)
   * [MD024 - Multiple headers with the same content](#md024---multiple-headers-with-the-same-content)
   * [MD025 - Multiple top level headers in the same document](#md025---multiple-top-level-headers-in-the-same-document)
   * [MD026 - Trailing punctuation in header](#md026---trailing-punctuation-in-header)
   * [MD027 - Multiple spaces after blockquote symbol](#md027---multiple-spaces-after-blockquote-symbol)
   * [MD028 - Blank line inside blockquote](#md028---blank-line-inside-blockquote)
   * [MD029 - Ordered list item prefix](#md029---ordered-list-item-prefix)
   * [MD030 - Spaces after list markers](#md030---spaces-after-list-markers)
   * [MD031 - Fenced code blocks should be surrounded by blank lines](#md031---fenced-code-blocks-should-be-surrounded-by-blank-lines)
   * [MD032 - Lists should be surrounded by blank lines](#md032---lists-should-be-surrounded-by-blank-lines)
   * [MD033 - Inline HTML](#md033---inline-html)
   * [MD034 - Bare URL used](#md034---bare-url-used)
   * [MD035 - Horizontal rule style](#md035---horizontal-rule-style)
   * [MD036 - Emphasis used instead of a header](#md036---emphasis-used-instead-of-a-header)
   * [MD037 - Spaces inside emphasis markers](#md037---spaces-inside-emphasis-markers)
   * [MD038 - Spaces inside code span elements](#md038---spaces-inside-code-span-elements)
   * [MD039 - Spaces inside link text](#md039---spaces-inside-link-text)
   * [MD040 - Fenced code blocks should have a language specified](#md040---fenced-code-blocks-should-have-a-language-specified)
   * [MD041 - First line in file should be a top level header](#md041---first-line-in-file-should-be-a-top-level-header)
   * [MD046 - Code block style](#md046---code-block-style)
   * [MD047 - File should end with a single newline character](#md047---file-should-end-with-a-single-newline-character)

# Rules

This document contains a description of all rules, what they are checking for,
as well as an examples of documents that break the rule and corrected
versions of the examples.

## MD001 - Header levels should only increment by one level at a time

Tags: headers

Aliases: header-increment

This rule is triggered when you skip header levels in a markdown document, for
example:

```markdown
# Header 1

### Header 3

We skipped out a 2nd level header in this document
```

When using multiple header levels, nested headers should increase by only one
level at a time:

```markdown
# Header 1

## Header 2

### Header 3

#### Header 4

## Another Header 2

### Another Header 3
```

## MD002 - First header should be a top level header

Tags: headers

Aliases: first-header-h1

Parameters: level (number; default 1)

This rule is triggered when the first header in the document isn't a h1 header:

```markdown
## This isn't a H1 header

### Another header
```

The first header in the document should be a h1 header:

```markdown
# Start with a H1 header

## Then use a H2 for subsections
```

## MD003 - Header style

Tags: headers

Aliases: header-style

Parameters: style (`:consistent`, `:atx`, `:atx_closed`, `:setext`,
`:setext_with_atx`; default `:consistent`)

This rule is triggered when different header styles (atx, setext, and 'closed'
atx) are used in the same document:

```markdown
# ATX style H1

## Closed ATX style H2 ##

Setext style H1
===============
```

Be consistent with the style of header used in a document:

```markdown
# ATX style H1

## ATX style H2
```

The setext_with_atx doc style allows atx-style headers of level 3 or more in
documents with setext style headers:

```markdown
Setext style H1
===============

Setext style H2
---------------

### ATX style H3
```

Note: the configured header style can be a specific style to use (atx,
atx_closed, setext, setext_with_atx), or simply require that the usage be
consistent within the document.

## MD004 - Unordered list style

Tags: bullet, ul

Aliases: ul-style

Parameters: style (`:consistent`, `:asterisk`, `:plus`, `:dash`, `:sublist`;
default `:consistent`)

This rule is triggered when the symbols used in the document for unordered
list items do not match the configured unordered list style:

```markdown
* Item 1
+ Item 2
- Item 3
```

To fix this issue, use the configured style for list items throughout the
document:

```markdown
* Item 1
* Item 2
* Item 3
```

Note: the configured list style can be a specific symbol to use (asterisk,
plus, dash), or simply require that the usage be consistent within the
document (consistent) or within a level (sublist).

For sublist, each level must be consistent within a document, even if they
are separate lists. So this is allowed:

```markdown
* Item 1
* Item 2
  - Item 2a
    + Item 2a1
  - Item 2b
* Item 3

Other stuff

* Item 1
* Item 2
```

But this is not allowed:

```markdown
* Item 1
* Item 2
  - Item 2a
    + Item 2a1
  - Item 2b
* Item 3

Other stuff

- Item 1
- Item 2
```

## MD005 - Inconsistent indentation for list items at the same level

Tags: bullet, ul, indentation

Aliases: list-indent

This rule is triggered when list items are parsed as being at the same level,
but don't have the same indentation:

```markdown
* Item 1
    * Nested Item 1
    * Nested Item 2
   * A misaligned item
```

Usually this rule will be triggered because of a typo. Correct the indentation
for the list to fix it:

```markdown
* Item 1
  * Nested Item 1
  * Nested Item 2
  * Nested Item 3
```

## MD006 - Consider starting bulleted lists at the beginning of the line

Tags: bullet, ul, indentation

Aliases: ul-start-left

This rule is triggered when top level lists don't start at the beginning of a
line:

```markdown
Some text

  * List item
  * List item
```

To fix, ensure that top level list items are not indented:

```markdown
Some test

* List item
* List item
```

Rationale: Starting lists at the beginning of the line means that nested list
items can all be indented by the same amount when an editor's indent function
or the tab key is used to indent. Starting a list 1 space in means that the
indent of the first nested list is less than the indent of the second level
(3 characters if you use 4 space tabs, or 1 character if you use 2 space tabs).

## MD007 - Unordered list indentation

Tags: bullet, ul, indentation

Aliases: ul-indent

Parameters: indent (number; default 3)

This rule is triggered when list items are not indented by the configured
number of spaces (default: 3).

Example:

```markdown
* List item
  * Nested list item indented by 2 spaces
```

Corrected Example:

```markdown
* List item
   * Nested list item indented by 3 spaces
```

Rationale (3 space indent): This matches the minimum possible indentation
for _ordered_ lists (i.e Kramdown won't parse anything less than 3 spaces
as a sublist on OLs), and since MD005 requires consistent indentation
across lists, anything less than three on this rule will cause a violation
of MD005 if you have both kinds of lists in the same document.

This means if you want to set this to 2, you'll need to disable MD005.

Rationale (4 space indent): Same indent as code blocks, simpler for editors to
implement. See
<https://cirosantilli.com/markdown-style-guide#spaces-before-list-marker>
for more information.

In addition, this is a compatibility issue with multi-markdown parsers, which
require a 4 space indents. See
<http://support.markedapp.com/discussions/problems/21-sub-lists-not-indenting>
for a description of the problem.

## MD009 - Trailing spaces

Tags: whitespace

Aliases: no-trailing-spaces

Parameters: br_spaces (number; default: 0)

This rule is triggered on any lines that end with whitespace. To fix this,
find the line that is triggered and remove any trailing spaces from the end.

The br_spaces parameter allows an exception to this rule for a specific amount
of trailing spaces used to insert an explicit line break/br element. For
example, set br_spaces to 2 to allow exactly 2 spaces at the end of a line.

Note: you have to set br_spaces to 2 or higher for this exception to take
effect - you can't insert a br element with just a single trailing space, so
if you set br_spaces to 1, the exception will be disabled, just as if it was
set to the default of 0.

## MD010 - Hard tabs

Tags: whitespace, hard_tab

Aliases: no-hard-tabs

Parameters: ignore_code_blocks (boolean; default false)

This rule is triggered by any lines that contain hard tab characters instead
of using spaces for indentation. To fix this, replace any hard tab characters
with spaces instead.

Example:

```markdown
Some text

	* hard tab character used to indent the list item
```

Corrected example:

```markdown
Some text

    * Spaces used to indent the list item instead
```

You have the option to exclude this rule for code blocks. To do this, set the
`ignore_code_blocks` parameter to true.

## MD011 - Reversed link syntax

Tags: links

Aliases: no-reversed-links

This rule is triggered when text that appears to be a link is encountered, but
where the syntax appears to have been reversed (the `[]` and `()` are
reversed):

```markdown
(Incorrect link syntax)[http://www.example.com/]
```

To fix this, swap the `[]` and `()` around:

```markdown
[Correct link syntax](http://www.example.com/)
```

## MD012 - Multiple consecutive blank lines

Tags: whitespace, blank_lines

Aliases: no-multiple-blanks

This rule is triggered when there are multiple consecutive blank lines in the
document:

```markdown
Some text here


Some more text here
```

To fix this, delete the offending lines:

```markdown
Some text here

Some more text here
```

Note: this rule will not be triggered if there are multiple consecutive blank
lines inside code blocks.

## MD013 - Line length

Tags: line_length

Aliases: line-length

Parameters: line_length, ignore_code_blocks, code_blocks, tables (number;
default 80, boolean; default false, boolean; default true, boolean; default
true)

This rule is triggered when there are lines that are longer than the
configured line length (default: 80 characters). To fix this, split the line
up into multiple lines.

This rule has an exception where there is no whitespace beyond the configured
line length. This allows you to still include items such as long URLs without
being forced to break them in the middle.

You also have the option to exclude this rule for code blocks. To
do this, set the `ignore_code_blocks` parameter to true. To exclude this rule
for tables set the `tables` parameters to false.  Setting the parameter
`code_blocks` to false to exclude the rule for code blocks is deprecated and
will be removed in a future release.

Code blocks are included in this rule by default since it is often a
requirement for document readability, and tentatively compatible with code
rules. Still, some languages do not lend themselves to short lines.

## MD014 - Dollar signs used before commands without showing output

Tags: code

Aliases: commands-show-output

This rule is triggered when there are code blocks showing shell commands to be
typed, and the shell commands are preceded by dollar signs ($):

```markdown
$ ls
$ cat foo
$ less bar
```

The dollar signs are unnecessary in the above situation, and should not be
included:

```markdown
ls
cat foo
less bar
```

However, an exception is made when there is a need to distinguish between
typed commands and command output, as in the following example:

```markdown
$ ls
foo bar
$ cat foo
Hello world
$ cat bar
baz
```

Rationale: it is easier to copy and paste and less noisy if the dollar signs
are omitted when they are not needed. See
<https://cirosantilli.com/markdown-style-guide#dollar-signs-in-shell-code>
for more information.

## MD018 - No space after hash on atx style header

Tags: headers, atx, spaces

Aliases: no-missing-space-atx

This rule is triggered when spaces are missing after the hash characters
in an atx style header:

```markdown
#Header 1

##Header 2
```

To fix this, separate the header text from the hash character by a single
space:

```markdown
# Header 1

## Header 2
```

## MD019 - Multiple spaces after hash on atx style header

Tags: headers, atx, spaces

Aliases: no-multiple-space-atx

This rule is triggered when more than one space is used to separate the
header text from the hash characters in an atx style header:

```markdown
#  Header 1

##  Header 2
```

To fix this, separate the header text from the hash character by a single
space:

```markdown
# Header 1

## Header 2
```

## MD020 - No space inside hashes on closed atx style header

Tags: headers, atx_closed, spaces

Aliases: no-missing-space-closed-atx

This rule is triggered when spaces are missing inside the hash characters
in a closed atx style header:

```markdown
#Header 1#

##Header 2##
```

To fix this, separate the header text from the hash character by a single
space:

```markdown
# Header 1 #

## Header 2 ##
```

Note: this rule will fire if either side of the header is missing spaces.

## MD021 - Multiple spaces inside hashes on closed atx style header

Tags: headers, atx_closed, spaces

Aliases: no-multiple-space-closed-atx

This rule is triggered when more than one space is used to separate the
header text from the hash characters in a closed atx style header:

```markdown
#  Header 1  #

##  Header 2  ##
```

To fix this, separate the header text from the hash character by a single
space:

```markdown
# Header 1 #

## Header 2 ##
```

Note: this rule will fire if either side of the header contains multiple
spaces.

## MD022 - Headers should be surrounded by blank lines

Tags: headers, blank_lines

Aliases: blanks-around-headers

This rule is triggered when headers (any style) are either not preceded or not
followed by a blank line:

```markdown
# Header 1
Some text

Some more text
## Header 2
```

To fix this, ensure that all headers have a blank line both before and after
(except where the header is at the beginning or end of the document):

```markdown
# Header 1

Some text

Some more text

## Header 2
```

Rationale: Aside from aesthetic reasons, some parsers, including kramdown, will
not parse headers that don't have a blank line before, and will parse them as
regular text.

## MD023 - Headers must start at the beginning of the line

Tags: headers, spaces

Aliases: header-start-left

This rule is triggered when a header is indented by one or more spaces:

```markdown
Some text

  # Indented header
```

To fix this, ensure that all headers start at the beginning of the line:

```markdown
Some text

# Header
```

Rationale: Headers that don't start at the beginning of the line will not be
parsed as headers, and will instead appear as regular text.

## MD024 - Multiple headers with the same content

Tags: headers

Aliases: no-duplicate-header

Parameters: allow_different_nesting (boolean; default false)

This rule is triggered if there are multiple headers in the document that have
the same text:

```markdown
# Some text

## Some text
```

To fix this, ensure that the content of each header is different:

```markdown
# Some text

## Some more text
```

Rationale: Some markdown parses generate anchors for headers based on the
header name, and having headers with the same content can cause problems with
this.

If the parameter `allow_different_nesting` is set to `true`, header duplication
under different nesting is allowed, like it usually happens in change logs:

```markdown
# Change log

## 2.0.0

### Bug fixes

### Features

## 1.0.0

### Bug fixes
```

## MD025 - Multiple top level headers in the same document

Tags: headers

Aliases: single-h1

Parameters: level (number; default 1)

This rule is triggered when a top level header is in use (the first line of
the file is a h1 header), and more than one h1 header is in use in the
document:

```markdown
# Top level header

# Another top level header
```

To fix, structure your document so that there is a single h1 header that is
the title for the document, and all later headers are h2 or lower level
headers:

```markdown
# Title

## Header

## Another header
```

Rationale: A top level header is a h1 on the first line of the file, and
serves as the title for the document. If this convention is in use, then there
can not be more than one title for the document, and the entire document
should be contained within this header.

Note: The `level` parameter can be used to change the top level (ex: to h2) in
cases where an h1 is added externally.

## MD026 - Trailing punctuation in header

Tags: headers

Aliases: no-trailing-punctuation

Parameters: punctuation (string; default ".,;:!?")

This rule is triggered on any header that has a punctuation character as the
last character in the line:

```markdown
# This is a header.
```

To fix this, remove any trailing punctuation:

```markdown
# This is a header
```

Note: The punctuation parameter can be used to specify what characters class
as punctuation at the end of the header. For example, you can set it to
`'.,;:!'` to allow headers with question marks in them, such as might be used
in an FAQ.

## MD027 - Multiple spaces after blockquote symbol

Tags: blockquote, whitespace, indentation

Aliases: no-multiple-space-blockquote

This rule is triggered when blockquotes have more than one space after the
blockquote (`>`) symbol:

```markdown
>  This is a block quote with bad indentation
>  there should only be one.
```

To fix, remove any extraneous space:

```markdown
> This is a blockquote with correct
> indentation.
```

## MD028 - Blank line inside blockquote

Tags: blockquote, whitespace

Aliases: no-blanks-blockquote

This rule is triggered when two blockquote blocks are separated by nothing
except for a blank line:

```markdown
> This is a blockquote
> which is immediately followed by

> this blockquote. Unfortunately
> In some parsers, these are treated as the same blockquote.
```

To fix this, ensure that any blockquotes that are right next to each other
have some text in between:

```markdown
> This is a blockquote.

And Jimmy also said:

> This too is a blockquote.
```

Alternatively, if they are supposed to be the same quote, then add the
blockquote symbol at the beginning of the blank line:

```markdown
> This is a blockquote.
>
> This is the same blockquote.
```

Rationale: Some markdown parsers will treat two blockquotes separated by one
or more blank lines as the same blockquote, while others will treat them as
separate blockquotes.

## MD029 - Ordered list item prefix

Tags: ol

Aliases: ol-prefix

Parameters: style (`:one`, `:ordered`; default `:one`)

This rule is triggered on ordered lists that do not either start with '1.' or
do not have a prefix that increases in numerical order (depending on the
configured style, which defaults to 'one').

Example valid list if the style is configured as 'one':

```markdown
1. Do this.
1. Do that.
1. Done.
```

Example valid list if the style is configured as 'ordered':

```markdown
1. Do this.
2. Do that.
3. Done.
```

## MD030 - Spaces after list markers

Tags: ol, ul, whitespace

Aliases: list-marker-space

Parameters: ul_single, ol_single, ul_multi, ol_multi (number, default 1)

This rule checks for the number of spaces between a list marker (e.g. '`-`',
'`*`', '`+`' or '`1.`') and the text of the list item.

The number of spaces checked for depends on the document style in use, but the
default is 1 space after any list marker:

```markdown
* Foo
* Bar
* Baz

1. Foo
1. Bar
1. Baz

1. Foo
   * Bar
1. Baz
```

A document style may change the number of spaces after unordered list items
and ordered list items independently, as well as based on whether the content
of every item in the list consists of a single paragraph, or multiple
paragraphs (including sub-lists and code blocks).

For example, the style guide at
<https://cirosantilli.com/markdown-style-guide#spaces-after-list-marker>
specifies that 1 space after the list marker should be used if every item in
the list fits within a single paragraph, but to use 2 or 3 spaces (for ordered
and unordered lists respectively) if there are multiple paragraphs of content
inside the list:

```markdown
* Foo
* Bar
* Baz
```

vs.

```markdown
*   Foo

    Second paragraph

*   Bar
```

or

```markdown
1.  Foo

    Second paragraph

1.  Bar
```

To fix this, ensure the correct number of spaces are used after list marker
for your selected document style.

## MD031 - Fenced code blocks should be surrounded by blank lines

Tags: code, blank_lines

Aliases: blanks-around-fences

This rule is triggered when fenced code blocks are either not preceded or not
followed by a blank line:

    Some text
    ```
    Code block
    ```

    ```
    Another code block
    ```
    Some more text

To fix this, ensure that all fenced code blocks have a blank line both before
and after (except where the block is at the beginning or end of the document):

    Some text

    ```
    Code block
    ```

    ```
    Another code block
    ```

    Some more text

Rationale: Aside from aesthetic reasons, some parsers, including kramdown, will
not parse fenced code blocks that don't have blank lines before and after them.

## MD032 - Lists should be surrounded by blank lines

Tags: bullet, ul, ol, blank_lines

Aliases: blanks-around-lists

This rule is triggered when lists (of any kind) are either not preceded or not
followed by a blank line:

```markdown
Some text
* Some
* List

1. Some
2. List
Some text
```

To fix this, ensure that all lists have a blank line both before and after
(except where the block is at the beginning or end of the document):

```markdown
Some text

* Some
* List

1. Some
2. List

Some text
```

Rationale: Aside from aesthetic reasons, some parsers, including kramdown, will
not parse lists that don't have blank lines before and after them.

Note: List items without hanging indents are a violation of this rule; list
items with hanging indents are okay:

```markdown
* This is
not okay

* This is
  okay
```

## MD033 - Inline HTML

Tags: html

Aliases: no-inline-html

Parameters: allowed_elements (string; default `''`)

This rule is triggered whenever raw HTML is used in a markdown document:

```markdown
<h1>Inline HTML header</h1>
```

To fix this, use 'pure' markdown instead of including raw HTML:

```markdown
# Markdown header
```

Note: To allow specific HTML elements, use the `allowed_elements` parameter:

```ruby
rule 'MD033', :allowed_elements => 'br, p'
```

Rationale: Raw HTML is allowed in markdown, but this rule is included for
those who want their documents to only include "pure" markdown, or for those
who are rendering markdown documents in something other than HTML.

## MD034 - Bare URL used

Tags: links, url

Aliases: no-bare-urls

This rule is triggered whenever a URL is given that isn't surrounded by angle
brackets:

```markdown
For more information, see http://www.example.com/.
```

To fix this, add angle brackets around the URL:

```markdown
For more information, see <http://www.example.com/>.
```

Rationale: Without angle brackets, the URL isn't converted into a link in many
markdown parsers.

Note: if you do want a bare URL without it being converted into a link,
enclose it in a code block, otherwise in some markdown parsers it _will_ be
converted:

```markdown
`http://www.example.com`
```

## MD035 - Horizontal rule style

Tags: hr

Aliases: hr-style

Parameters: style (`:consistent`, "---", "***", or other string specifying the
horizontal rule; default `:consistent`)

This rule is triggered when inconsistent styles of horizontal rules are used
in the document:

```markdown
---

- - -

***

* * *

****
```

To fix this, ensure any horizontal rules used in the document are consistent,
or match the given style if the rule is so configured:

```markdown
---

---
```

Note: by default, this rule is configured to just require that all horizontal
rules in the document are the same, and will trigger if any of the horizontal
rules are different than the first one encountered in the document. If you
want to configure the rule to match a specific style, the parameter given to
the 'style' option is a string containing the exact horizontal rule text that
is allowed.

## MD036 - Emphasis used instead of a header

Tags: headers, emphasis

Parameters: punctuation (string; default ".,;:!?")

Aliases: no-emphasis-as-header

This check looks for instances where emphasized (i.e. bold or italic) text is
used to separate sections, where a header should be used instead:

```markdown
**My document**

Lorem ipsum dolor sit amet...

_Another section_

Consectetur adipiscing elit, sed do eiusmod.
```

To fix this, use markdown headers instead of emphasized text to denote
sections:

```markdown
# My document

Lorem ipsum dolor sit amet...

## Another section

Consectetur adipiscing elit, sed do eiusmod.
```

Note: this rule looks for single line paragraphs that consist entirely of
emphasized text.  It won't fire on emphasis used within regular text,
multi-line emphasized paragraphs, and paragraphs ending in punctuation.
Similarly to rule MD026, you can configure what characters are recognized as
punctuation.

## MD037 - Spaces inside emphasis markers

Tags: whitespace, emphasis

Aliases: no-space-in-emphasis

This rule is triggered when emphasis markers (bold, italic) are used, but they
have spaces between the markers and the text:

```markdown
Here is some ** bold ** text.

Here is some * italic * text.

Here is some more __ bold __ text.

Here is some more _ italic _ text.
```

To fix this, remove the spaces around the emphasis markers:

```markdown
Here is some **bold** text.

Here is some *italic* text.

Here is some more __bold__ text.

Here is some more _italic_ text.
```

Rationale: Emphasis is only parsed as such when the asterisks/underscores
aren't completely surrounded by spaces. This rule attempts to detect where
they were surrounded by spaces, but it appears that emphasized text was
intended by the author.

## MD038 - Spaces inside code span elements

Tags: whitespace, code

Aliases: no-space-in-code

This rule is triggered on code span elements that have spaces right inside the
backticks:

```markdown
` some text `

`some text `

` some text`
```

To fix this, remove the spaces inside the codespan markers:

```markdown
`some text`
```

## MD039 - Spaces inside link text

Tags: whitespace, links

Aliases: no-space-in-links

This rule is triggered on links that have spaces surrounding the link text:

```markdown
[ a link ](http://www.example.com/)
```

To fix this, remove the spaces surrounding the link text:

```markdown
[a link](http://www.example.com/)
```

## MD040 - Fenced code blocks should have a language specified

Tags: code, language

Aliases: fenced-code-language

This rule is triggered when fenced code blocks are used, but a language isn't
specified:

    ```
    #!/bin/bash
    echo Hello world
    ```

To fix this, add a language specifier to the code block:

    ```bash
    #!/bin/bash
    echo Hello world
    ```

If no specific language is used, you can specify `text` as language.

## MD041 - First line in file should be a top level header

Tags: headers

Aliases: first-line-h1

Parameters: level (number; default 1)

This rule is triggered when the first line in the file isn't a top level (h1)
header:

```markdown
This is a file without a header
```

To fix this, add a header to the top of your file:

```markdown
# File with header

This is a file with a top level header
```

Note: The `level` parameter can be used to change the top level (ex: to h2) in
cases where an h1 is added externally.

## MD046 - Code block style

Tags: code

Aliases: code-block-style

Parameters: style (`:fenced`, `:indented`, `:consistent`, default `:fenced`)

This rule is triggered when a different code block style is used than the
configured one. For example, in the default configuration this rule is triggered
for the following document:

    Some text.

        Code block

    Some more text.

To fix this, used fenced code blocks:

    Some text.

    ```ruby
    Code block
    ```

    Some more text.

The reverse is true if the rule is configured to use the `indented` style.

## MD047 - File should end with a single newline character

Tags: blank_lines

Aliases: single-trailing-newline

This rule is triggered when there is not a single newline character at the end
of a file.

Example that triggers the rule:

```markdown
# Heading

This file ends without a newline.[EOF]
```

To fix the violation, add a newline character to the end of the file:

```markdown
# Heading

This file ends with a newline.
[EOF]
```

Rationale: Some programs have trouble with files that do not end with a newline.
More information:
<https://unix.stackexchange.com/questions/18743/whats-the-point-in-adding-a-new-line-to-the-end-of-a-file>.
