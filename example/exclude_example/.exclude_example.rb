# This is a style file, which defines the sets of rules to include/exclude and any configuration
# for those rules. This must be included from your mdlrc using the `style` paramter.

# This is a sample style to exclude very long lines

# First, include all rules:
all
# Then, exclude MD013 (long lines), with:
exclude_rule "MD013"
# To, instead exclude code blocks triggering on long lines, use the following
#rule 'MD013', :ignore_code_blocks => true
