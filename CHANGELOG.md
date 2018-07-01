# Change Log

## [Unreleased]

### Changed

## [v0.5.0]

### Added

* Add md042 to enforce code block style
* JSON formatter/output

### Changed

* PR #200: allow different nesting on headers duplication check
* MD036 - Ignore multi-line emphasized paragraphs, and emphasized paragraphs
  that end in punctuation (#140)

### Fixed

* PR #168: fix issue numbers false positives
* Fix issue #102: lint MD039 checking for nodes inside link text

## [v0.4.0] (2016-08-22)

### Added

* Ignore yaml front matter option (#130, #143)

### Changed

* Allow top level header rules (MD002, MD025, MD041) to be configurable (#142)

### Fixed

* Read UTF-8 files correctly even if locale is set to C (#135, #146, #147,
  #148)
* Fix issues loading .mdlrc file (#126, #129, #133, #148)
* Fix erroneous triggering of MD022/MD023 in some cases (#144)
* Detect codeblock lines correctly when ignoring them (#141)

## [v0.3.1] (2016-03-20)

### Fixed

* Fix error on starting mdl

## [v0.3.0] (2016-03-19)

### Rules added

* MD041 - First line in file should be a top level header

### Added

* You can now load your own custom rules with the `-u` option. See
  [rules.rb](https://github.com/markdownlint/markdownlint/blob/master/lib/mdl/rules.rb)
  for an example of what a rules file looks like. Use the `-d` option if you
  don't want to load markdownlint's default ruleset.
* You can now refer to rules by human-readable/writable aliases, such as
  'ul-style' instead of 'MD004'. See RULES.md for a list of the rule aliases.
  You can pass the `-a` option to display rule aliases instead of MDxxx rule
  IDs.

### Changed

* MD003 - An additional header style, setext_with_atx, was added to require
  setext style headers for levels 1 and 2, but allow atx style headers for
  levels 3 and above (i.e. header levels that can't be expressed with setext
  style headers)
* MD013 - You now have the option to exclude code blocks and tables from the
  line length limit check.

### Fixed

* Crash with MD034 and pipe character (#93, #97)
* MD031 failed on nested code blocks (#100, #109)
* MD037 crashes on <li> with underscores (#83)
* Regression introduced in v0.2.1 - ignoring rules/tags on the command line
  caused a crash (#108)
* MD027 false positive when line starts with a backtick (#105)

### Merged pull requests

* [Add support for nested code fences to MD031/MD032 - David
  Anson](https://github.com/markdownlint/markdownlint/pull/109)
* [Add missing word to description of MD035 in RULES.md - David
  Anson](https://github.com/markdownlint/markdownlint/pull/86)
* [Probe for .mdlrc in current and parent directories - Loic
  Nageleisen](https://github.com/markdownlint/markdownlint/pull/111)
* [MD013: allow excluding code blocks and tables - Loic
  Nageleisen](https://github.com/markdownlint/markdownlint/pull/112)

## [v0.2.1] (2015-04-13)

### Fixed

* Incorrect parsing of rules/tags specification in .mdlrc (#81)
* Exception on image links with MD039 (#82)
* MD037 flags on two words beginning with underscores on the same line. (#83)

### Known issues

* Exception on some lines with raw html list items in them (#83)

## [v0.2.0] (2015-04-13)

### Rules added

* MD033 - Inline HTML
* MD034 - Bare URL used
* MD035 - Horizontal rule style
* MD036 - Emphasis used instead of a header
* MD037 - Spaces inside emphasis markers
* MD038 - Spaces inside code span elements
* MD039 - Spaces inside link text
* MD040 - Fenced code blocks should have a language specified

## Added

* Trailing spaces rule should allow an excemption for deliberate <br/\>
  insertion.
* Rules can be excluded in .mdlrc and on the command line by specifying a rule
  as ~MD000.

### Merged pull requests

* [Add parameter (value and default) information to rule documentation. - David Anson](https://github.com/markdownlint/markdownlint/pull/76)

## [v0.1.0] (2015-02-22)

### Rules added

* MD031 - Fenced code blocks should be surrounded by blank lines
* MD032 - Lists should be surrounded by blank lines

### Fixed

* MD014 triggers when it shouldn't

### Merged pull requests

* [MD032 - Lists should be surrounded by blank lines - David Anson](https://github.com/markdownlint/markdownlint/pull/70)
* [MD031 - Fenced code blocks should be surrounded by blank lines - David Anson](https://github.com/markdownlint/markdownlint/pull/68)
* [Clarify how to specify your own style - mjankowski](https://github.com/markdownlint/markdownlint/pull/65)
* [Use single quotes to prevent early escaping - highb](https://github.com/markdownlint/markdownlint/pull/64)

## [v0.0.1] (2014-09-07)

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

[Unreleased]: https://github.com/markdownlint/markdownlint/tree/master
[v0.4.0]: https://github.com/markdownlint/markdownlint/tree/v0.4.0
[v0.3.1]: https://github.com/markdownlint/markdownlint/tree/v0.3.1
[v0.3.0]: https://github.com/markdownlint/markdownlint/tree/v0.3.0
[v0.2.1]: https://github.com/markdownlint/markdownlint/tree/v0.2.1
[v0.2.0]: https://github.com/markdownlint/markdownlint/tree/v0.2.0
[v0.1.0]: https://github.com/markdownlint/markdownlint/tree/v0.1.0
[v0.0.1]: https://github.com/markdownlint/markdownlint/tree/v0.0.1
