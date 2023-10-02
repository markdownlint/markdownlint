# Change Log

## Unreleased

### Fixed

* Fix Markdown lint version in SARIF output test [#469](https://github.com/markdownlint/markdownlint/pull/469)

### Rules Added

* MD055 - Tables: Each row must start and end with a `|` [#464](https://github.com/markdownlint/markdownlint/pull/464)
* MD056 - Tables: Number of columns is the same for all
  rows [#464](https://github.com/markdownlint/markdownlint/pull/464)
* MD057 - Tables: In the second row every column must have at least `---`,
  possibly surrounded with alignment `:` chars [#464](https://github.com/markdownlint/markdownlint/pull/464)

### Added

* Add SARIF output [#459](https://github.com/markdownlint/markdownlint/pull/459)
* Document DCO process better [#448](https://github.com/markdownlint/markdownlint/pull/448)
  and [#449](https://github.com/markdownlint/markdownlint/pull/449)

### Changed

* MD009 - Allow exactly 2 trailing spaces by default [#452](https://github.com/markdownlint/markdownlint/pull/452)
* MD033 - Add `allowed_elements` parameter [#450](https://github.com/markdownlint/markdownlint/pull/450)
* Updated build instructions [#431](https://github.com/markdownlint/markdownlint/pull/431)

### Fixed

* MD027 - handle anchor elements correctly [#463](https://github.com/markdownlint/markdownlint/pull/463)
* Fix examples for RULES.md for MD007 [#462](https://github.com/markdownlint/markdownlint/pull/462)
* Fix links to use https instead of http [#447](https://github.com/markdownlint/markdownlint/pull/447)
* Make RULES.md comply with our own rules [#439](https://github.com/markdownlint/markdownlint/pull/439)
* Fix docker builds [#429](https://github.com/markdownlint/markdownlint/pull/429)

## [v0.12.0] (2022-10-17)

### Rules Added

* MD047 - File should end with a blank line

### Added

* New 'docs' method on rules to provide a URL and longer description
* `docker_image`-based pre-commit

### Changed

* Changed the default for MD007 to 3 spaces to match minimum spaces for ordered lists
* Added option `:ignore_code_blocks` to rule MD010. If set to true, hard tabs in
  code blocks will be ignored.
* Added option `:ignore_code_blocks` to rule MD013. If set to true, hard tabs in
  code blocks will be ignored. The option `:code_blocks` has been marked as
  deprecated in the documentation. If `:code_blocks` is set to false in the
  configuration, a deprecation warning is printed.
* Improved documentation on custom rules and rulesets
* Handle non-printable characters gracefully
* Support configurable sublist styles for MD004

### Fixed

* Fixed directory argument with `--git-recurse`
* Preserve empty lines at the end of a file

## [v0.11.0] (2020-08-22)

### Fixed

* Fixed crash when using `-g`
* Fixed missing dependencies in docker image

## [v0.10.0] (2020-08-08)

### Added

* More examples of mdlrc and style files
* Added CI for Rubocop and Markdownlint on our own repo

### Fixed

* Update Dockerfile to work with modern mdl
* Update minimum version of kramdown for security advisory
* Update minimum version of rubocop for security advisory

## [v0.9.0] (2020-02-21)

### Changed

* Better error messages on missing styles [#302](https://github.com/markdownlint/markdownlint/pull/302)
* Use require_relative to speed up requires [#297](https://github.com/markdownlint/markdownlint/pull/297)
* Bumped alpine version in the Dockerfile [#155](https://github.com/markdownlint/markdownlint/pull/155)

### Fixed

* Fix crash in --json [#286](https://github.com/markdownlint/markdownlint/pull/286)
* Handle codeblocks that are nested [#293](https://github.com/markdownlint/markdownlint/pull/293)
* Fix handling of blockquoted list items [#284](https://github.com/markdownlint/markdownlint/pull/284)

## [v0.8.0] (2019-11-08)

### Changed

* Don't ship test / example files in the gem artifact [#282](https://github.com/markdownlint/markdownlint/pull/282)

### Fixed

* Handle newlines on Windows better [#238](https://github.com/markdownlint/markdownlint/pull/238)

## [v0.7.0] (2019-10-24)

### Added

* Pull request and issue templates for users and contributors
* Move to kramdown 2
* Handle Kramdown TOC
* Loosen various dependencies and move minimum ruby version to 2.4

## [v0.6.0] (2019-10-19)

### Added

* There are now CONTRIBUTING.md and MAINTAINERS.md docs
* There is now a `.pre-commit-hooks.yaml` for those who want to use pre-commit.com

### Changed

* Ignore blank line after front matter [#248](https://github.com/markdownlint/markdownlint/pull/248)
* Only import JSON when necessary [#231](https://github.com/markdownlint/markdownlint/pull/231)
* Use newere mixlib-cli [#265](https://github.com/markdownlint/markdownlint/pull/265)
* Nicer error message when activating nonexistent rule [#246](https://github.com/markdownlint/markdownlint/pull/246)
* Fix documentation on `ignore_front_matter` [#241](https://github.com/markdownlint/markdownlint/pull/241)
* Update docs to use "MY" prefix for custom rule example [#245](https://github.com/markdownlint/markdownlint/pull/245)
* Fix crash in MD039 when the link text is empty [#256](https://github.com/markdownlint/markdownlint/pull/256)
* Reference Node.js markdownlint [#229](https://github.com/markdownlint/markdownlint/pull/229)
* Added table of contents to RULES.md for easier
  navigation [#232](https://github.com/markdownlint/markdownlint/pull/232)
* Fix typos in MD046 docs [#219](https://github.com/markdownlint/markdownlint/pull/219)
* Fixed MD036 crash [#222](https://github.com/markdownlint/markdownlint/pull/222)

### Removed

## [v0.5.0] (2018-07-01)

### Added

* Add md042 to enforce code block style
* JSON formatter/output

### Changed

* Allow different nesting on headers duplication check [#200](https://github.com/markdownlint/markdownlint/pull/200)
* MD036 - Ignore multi-line emphasized paragraphs, and emphasized paragraphs
  that end in punctuation [#140](https://github.com/markdownlint/markdownlint/pull/140)

### Fixed

* Fix issue numbers false positives [#168](https://github.com/markdownlint/markdownlint/pull/168)
* Lint MD039 checking for nodes inside link text [#102](https://github.com/markdownlint/markdownlint/issues/102)

## [v0.4.0] (2016-08-22)

### Added

* Ignore yaml front matter option [#130](https://github.com/markdownlint/markdownlint/pull/130)
  and [#143](https://github.com/markdownlint/markdownlint/pull/143)

### Changed

* Allow top level header rules (MD002, MD025, MD041) to be
  configurable [#142](https://github.com/markdownlint/markdownlint/pull/142)

### Fixed

* Read UTF-8 files correctly even if locale is set to
  C [#135](https://github.com/markdownlint/markdownlint/pull/135),
  [#146](https://github.com/markdownlint/markdownlint/pull/146),
  [#147](https://github.com/markdownlint/markdownlint/pull/147)
  and [#148](https://github.com/markdownlint/markdownlint/pull/148)
* Fix issues loading .mdlrc
  file [#126](https://github.com/markdownlint/markdownlint/pull/126),
  [#129](https://github.com/markdownlint/markdownlint/pull/129),
  [#133](https://github.com/markdownlint/markdownlint/pull/133)
  and [#148](https://github.com/markdownlint/markdownlint/pull/148)
* Fix erroneous triggering of MD022/MD023 in some cases [#144](https://github.com/markdownlint/markdownlint/pull/144)
* Detect codeblock lines correctly when ignoring them [#141](https://github.com/markdownlint/markdownlint/pull/141)

## [v0.3.1] (2016-03-20)

### Fixed

* Fix error on starting mdl

## [v0.3.0] (2016-03-19)

### Rules added

* MD041 - First line in file should be a top level header

### Added

* You can now load your own custom rules with the `-u` option. See
  [rules.rb](https://github.com/markdownlint/markdownlint/blob/main/lib/mdl/rules.rb)
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

* Crash with MD034 and pipe character [#93](https://github.com/markdownlint/markdownlint/pull/93)
  and [#97](https://github.com/markdownlint/markdownlint/pull/97)
* MD031 failed on nested code blocks [#100](https://github.com/markdownlint/markdownlint/pull/100)
  and [#109](https://github.com/markdownlint/markdownlint/pull/109)
* MD037 crashes on <li> with underscores [#83](https://github.com/markdownlint/markdownlint/pull/83)
* Regression introduced in v0.2.1 - ignoring rules/tags on the command line
  caused a crash [#108](https://github.com/markdownlint/markdownlint/pull/108)
* MD027 false positive when line starts with a backtick [#105](https://github.com/markdownlint/markdownlint/pull/105)

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

* Incorrect parsing of rules/tags specification in .mdlrc [#81](https://github.com/markdownlint/markdownlint/pull/81)
* Exception on image links with MD039 [#82](https://github.com/markdownlint/markdownlint/pull/82)
* MD037 flags on two words beginning with underscores on the same
  line [#83](https://github.com/markdownlint/markdownlint/pull/83)

### Known issues

* Exception on some lines with raw html list items in them [#83](https://github.com/markdownlint/markdownlint/pull/83)

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

[Unreleased]: https://github.com/markdownlint/markdownlint/tree/main
[v0.13.0]: https://github.com/markdownlint/markdownlint/tree/v0.13.0
[v0.12.0]: https://github.com/markdownlint/markdownlint/tree/v0.12.0
[v0.11.0]: https://github.com/markdownlint/markdownlint/tree/v0.11.0
[v0.10.0]: https://github.com/markdownlint/markdownlint/tree/v0.10.0
[v0.9.0]: https://github.com/markdownlint/markdownlint/tree/v0.9.0
[v0.8.0]: https://github.com/markdownlint/markdownlint/tree/v0.8.0
[v0.7.0]: https://github.com/markdownlint/markdownlint/tree/v0.7.0
[v0.6.0]: https://github.com/markdownlint/markdownlint/tree/v0.6.0
[v0.5.0]: https://github.com/markdownlint/markdownlint/tree/v0.5.0
[v0.4.0]: https://github.com/markdownlint/markdownlint/tree/v0.4.0
[v0.3.1]: https://github.com/markdownlint/markdownlint/tree/v0.3.1
[v0.3.0]: https://github.com/markdownlint/markdownlint/tree/v0.3.0
[v0.2.1]: https://github.com/markdownlint/markdownlint/tree/v0.2.1
[v0.2.0]: https://github.com/markdownlint/markdownlint/tree/v0.2.0
[v0.1.0]: https://github.com/markdownlint/markdownlint/tree/v0.1.0
[v0.0.1]: https://github.com/markdownlint/markdownlint/tree/v0.0.1
