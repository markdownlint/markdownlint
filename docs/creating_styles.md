# Creating styles

A 'style' in markdownlint is simply a ruby file specifying the list of enabled
and disabled rules, as well as specifying parameters for any rules that need
parameters different than the defaults.

The various options you can use in a style file are:

* all - include all rules
* rule - include a specific rule.

        rule 'MD001'

* exclude_rule - exclude a previously included rule. Used if you want to
  include all except for a few rules.

        exclude_rule 'MD000'

* tag - include all rules that are tagged with a specific value

        tag :whitespace

* exclude_tag - exclude all rules tagged with the specified tag

        exclude_tag :line_length

Note that tags are specified as symbols, and rule names as strings, just as
in the rule definitions themselves.

The last matching option wins, so you should always put `'all'` at the top of
the file (if you want to include all rules), then tags (and tag excludes),
then specific rules. In other words, go from least to most specific.

## Parameters

If you specify any parameters after a rule ID, then those values will be used
for the rules instead of the default. You only need to specify parameters for
any values you wish to override. For example, the default values for the
parameters in MD030 (spaces after list markers) are all 1. If you still want
the spaces after the list markers to be 1 in some cases, then you can exclude
those parameters:

    rule 'MD030', :ol_multi => 2, :ul_multi => 3

Even if a rule is included already by a tag specification (or 'all'), it is
not a problem to add a specific 'rule' entry in order to set custom
parameters, and is in fact necessary to do so.
