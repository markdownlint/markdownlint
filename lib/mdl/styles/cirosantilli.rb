# Ruleset that only contains rules that enforce the style guide at
rule 'MD001'

# MD002 - it's not clear that the first header should always be h1

rule 'MD003' # Redundant because of MD015
rule 'MD004' # Soon to be Redundant because of MDXXX (bullet style)

# MD005 - indentation of lists is explicit

rule 'MD006' # From indented lists section - 1st level has no indent
rule 'MD007' # Not multi-markdown, but the syle guide says 4 space indents

# MD008 enforces 2 space indents for lists

rule 'MD009'
rule 'MD010' # No hard tabs isn't an explicit rule, but implied by indent rules
rule 'MD011' # Not a style guide rule, but catches mistakes
rule 'MD012'
rule 'MD013' # 80 char limit might be more strict than the style guide
rule 'MD014'
rule 'MD015'

# MD016-17 enforce non-atx style headers

rule 'MD018'
rule 'MD019'

# MD020-21 are for non-atx style headers

rule 'MD022'
rule 'MD023'
rule 'MD024'
rule 'MD025'
rule 'MD026'
