# This is an example style file.
#
# This file defines the rules to include/exclude and/or parameters
# of those rules.
# This must be included from your .mdlrc using the `style` paramter.

# This is a sample style to exclude very long lines

# First, include all rules:
all
# Then, exclude MD013 (long lines), with:
exclude_rule 'MD013'

# The above excludes all long lines. If, instead, you want to only
# exclude code blocks with long lines, use the following:
# rule 'MD013', :ignore_code_blocks => true
