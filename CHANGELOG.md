# Change Log

## [v0.2.1](https://github.com/mivok/markdownlint/tree/v0.2.1) (2015-04-13)

[Full Changelog](https://github.com/mivok/markdownlint/compare/v0.2.0...v0.2.1)

### Bugs fixed

* Incorrect parsing of rules/tags specification in .mdlrc (#81)
* Exception on image links with MD039 (#82)
* MD037 flags on two words beginning with underscores on the same line. (#83)

### Known issues

* Exception on some lines with raw html list items in them (#83)

## [v0.2.0](https://github.com/mivok/markdownlint/tree/v0.2.0) (2015-04-13)

[Full Changelog](https://github.com/mivok/markdownlint/compare/v0.1.0...v0.2.0)

### Rules added

* MD033 - Inline HTML
* MD034 - Bare URL used
* MD035 - Horizontal rule style
* MD036 - Emphasis used instead of a header
* MD037 - Spaces inside emphasis markers
* MD038 - Spaces inside code span elements
* MD039 - Spaces inside link text
* MD040 - Fenced code blocks should have a language specified

## Enhancements implemented

* Trailing spaces rule should allow an excemption for deliberate <br/\>
  insertion.
* Rules can be excluded in .mdlrc and on the command line by specifying a rule
  as ~MD000.

### Merged pull requests

* [Add parameter (value and default) information to rule documentation. - David Anson](https://github.com/mivok/markdownlint/pull/76)

## [v0.1.0](https://github.com/mivok/markdownlint/tree/v0.1.0) (2015-02-22)

[Full Changelog](https://github.com/mivok/markdownlint/compare/v0.0.1...v0.1.0)

### Rules added

* MD031 - Fenced code blocks should be surrounded by blank lines
* MD032 - Lists should be surrounded by blank lines

### Bugs fixed

* MD014 triggers when it shouldn't

### Merged pull requests

* [MD032 - Lists should be surrounded by blank lines - David Anson](https://github.com/mivok/markdownlint/pull/70)
* [MD031 - Fenced code blocks should be surrounded by blank lines - David Anson](https://github.com/mivok/markdownlint/pull/68)
* [Clarify how to specify your own style - mjankowski](https://github.com/mivok/markdownlint/pull/65)
* [Use single quotes to prevent early escaping - highb](https://github.com/mivok/markdownlint/pull/64)

## [v0.0.1](https://github.com/mivok/markdownlint/tree/v0.0.1) (2014-09-07)

### Rules added

* MD001 - Header levels should only increment by one level at a time
* MD002 - First header should be a h1 header
* MD003 - Header style
* MD004 - Unordered list style
* MD005 - Inconsistent indentation for list items at the same level
* MD006 - Consider starting bulleted lists at the beginning of the line
* MD007 - Unordered list indentation
* MD009 - Trailing spaces
* MD010 - Hard tabs
* MD011 - Reversed link syntax
* MD012 - Multiple consecutive blank lines
* MD013 - Line length
* MD014 - Dollar signs used before commands without showing output
* MD018 - No space after hash on atx style header
* MD019 - Multiple spaces after hash on atx style header
* MD020 - No space inside hashes on closed atx style header
* MD021 - Multiple spaces inside hashes on closed atx style header
* MD022 - Headers should be surrounded by blank lines
* MD023 - Headers must start at the beginning of the line
* MD024 - Multiple headers with the same content
* MD025 - Multiple top level headers in the same document
* MD026 - Trailing punctuation in header
* MD027 - Multiple spaces after blockquote symbol
* MD028 - Blank line inside blockquote
* MD029 - Ordered list item prefix
* MD030 - Spaces after list markers
