# Enforce the style guide at https://cirosantilli.com/markdown-style-guide
all
rule 'MD003', :style => :atx
rule 'MD004', :style => :dash
rule 'MD007', :indent => 4
rule 'MD030', :ul_multi => 3, :ol_multi => 2
rule 'MD035', :style => '---'

# Inline HTML - this isn't forbidden by the style guide, and raw HTML use is
# explicitly mentioned in the 'email automatic links' section.
exclude_rule 'MD033'

# File should end with a single newline character
# this isn't forbidden by the style guide
exclude_rule 'MD047'
