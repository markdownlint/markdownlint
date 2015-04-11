# Mdl configuration

Markdownlint has several options you can configure both on the command line,
or in markdownlint's configuration file: `.mdlrc` in your home directory.
While markdownlint will work perfectly well out of the box, this page
documents some of the options you can change to suit your needs.

In general, anything you pass on the command line can also be put into
`~/.mdlrc` with the same option. For example, if you pass `--style foo` on the
command line, you can make this the default by putting `style "foo"` into your
`~/.mdlrc` file.

## Configuration options

### General options

Verbose - Print additional information about what markdownlint is doing.

* Command line: `-v`, `--verbose`
* Config file: `verbose true`
* Default: false

Show warnings - Kramdown will generate warnings of its own for some issues
found with documents during parsing, and markdownlint can print these out in
addition to using the built in rules. This option enables/disables that
behavior.

* Command line: `-w`, `--warnings`
* Config file: `show_kramdown_warnings true`
* Default: true

Recurse using files known to git - When mdl is given a directory name on the
command line, it will recurse into that directory looking for markdown files
to process. If this option is enabled, it will use git to look for files
instead, and ignore any files git doesn't know about.

* Command line: `-g`, `--git-recurse`
* Config file: `git_recurse true`
* Default: false

### Specifying which rules mdl processes

Tags - Limit the rules mdl enables to those containing the provided tags.

* Command line: `-t tag1,tag2`, `--tags tag1,tag2`, `-t ~tag1,~tag2`
* Config file: `tags "tag1", "tag2"`
* Default: process all rules (no tag limit)

Rules - Limit the rules mdl enables to those provided in this option.

* Command line: `-r MD001,MD002`, `--rules MD001,MD002`, `-r ~MD001,~MD002`
* Config file: `rules "MD001", "MD002"`
* Default: process all rules (no rule limit)

If a rule or tag ID is preceded by a tilde (`~`), then it _disables_ the
matching rules instead of enabling them, starting with all rules being enabled.

Note: if both `--rules` and `--tags` are provided, then a given rule has to
both be in the list of enabled rules, as well as be tagged with one of the
tags provided with the `--tags` option. Use the `-l/--list-rules` option to
test this behavior.

Style - Select which style mdl uses. A 'style' is a file containing a list of
enabled/disable rules, as well as options for some rules that take them. For
example, one style might enforce a line length of 80 characters, while another
might choose 72 characters, and another might have no line length limit at all
(rule MD013).

* Command line: `-s style_name`, `--style style_name`
* Config file: `style "style_name"`
* Default: Use the style called 'default'

Note: the value for `style_name` must either end with `.rb` or have `/` in it
in order to tell `mdl` to look for a custom style, and not a built-in style.
