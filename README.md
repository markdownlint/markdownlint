# Markdown lint tool 

[![Continuous Integration](https://github.com/markdownlint/markdownlint/workflows/Continuous%20Integration/badge.svg)](https://github.com/markdownlint/markdownlint/actions?query=workflow%3A%22Continuous+Integration%22)
[![Gem Version](https://badge.fury.io/rb/mdl.svg)](https://badge.fury.io/rb/mdl)

A tool to check markdown files and flag style issues.

## Installation

Markdownlint is packaged in some distributions as well as distributed via
RubyGems. Check the list below to see if it's packaged for your distribution,
and if so, feel free to use your distros package manager to install it.

[![Packaging status](https://repology.org/badge/vertical-allrepos/mdl-markdownlint.svg)](https://repology.org/project/mdl-markdownlint/versions)

To install from rubygems, run:

```shell
gem install mdl
```

Alternatively you can build it from source:

```shell
git clone https://github.com/markdownlint/markdownlint
cd markdownlint
rake install
```

Note that you will need [rake](https://github.com/ruby/rake)
(`gem install rake`) and [bundler](https://github.com/bundler/bundler)
(`gem install bundler`) in order to build from source.

## Usage

To have markdownlint check your markdown files, simply run `mdl` with the
filenames as a parameter:

```shell
mdl README.md
```

Markdownlint can also take a directory, and it will scan all markdown files
within the directory (and nested directories):

```shell
mdl docs/
```

If you don't specify a filename, markdownlint will use stdin:

```shell
cat foo.md | mdl
```

Markdownlint will output a list of issues it finds, and the line number where
the issue is. See [RULES.md](docs/RULES.md) for information on each issue, as
well as how to correct it:

```shell
README.md:1: MD013 Line length
README.md:70: MD029 Ordered list item prefix
README.md:71: MD029 Ordered list item prefix
README.md:72: MD029 Ordered list item prefix
README.md:73: MD029 Ordered list item prefix
```

Markdownlint has many more options you can pass on the command line, run
`mdl --help` to see what they are, or see the documentation on
[configuring markdownlint](docs/configuration.md).

### Styles

Not everyone writes markdown in the same way, and there are multiple flavors
and styles, each of which are valid. While markdownlint's default settings
will result in markdown files that reflect the author's preferred markdown
authoring preferences, your project may have different guidelines.

It's not markdownlint's intention to dictate any one specific style, and in
order to support these differing styles and/or preferences, markdownlint
supports what are called 'style files'. A style file is a file describing
which rules markdownlint should enable, and also what settings to apply to
individual rules. For example, rule [MD013](docs/RULES.md#md013---line-length)
checks for long lines, and by default will report an issue for any line longer
than 80 characters. If your project has a different maximum line length limit,
or if you don't want to enforce a line limit at all, then this can be
configured in a style file.

For more information on creating style files, see the
[creating styles](docs/creating_styles.md) document.

### Custom rules and rulesets

It may be that the rules provided in this project don't cover your stylistic
needs. To account for this, markdownlint supports the creation and use of custom
rules.

For more information, see the [creating rules](docs/creating_rules.md) document.

## Related projects

- [markdownlint](https://github.com/DavidAnson/markdownlint) - A similar
  project, but limited in Node.js
- [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) - A CLI
  for the above Node.js project
- [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) - An
  alternative CLI for the Node.js project

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more information.
