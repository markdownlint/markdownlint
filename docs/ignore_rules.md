# Ignoring rules

In order to ignore a particular rule in a document, you can add the `<!-- markdownlint-disable RULE-NAME -->` comment.

You can add this at the top of your file to ignore every repetition of the rule:

```markdown
// file.md
<!-- markdownlint-disable no-trailing-punctuation -->

<!-- All of the errors below will be ignored -->
# Trailing punctuation!

# Another trailing punctuation!

# Trailing punctuation again!
```

If you want to disable a rule for a line or set of lines, you can add `<!-- markdownlint-enable RULE-NAME -->` after the disabled block:

```markdown
// file.md

<!-- markdownlint-disable no-trailing-punctuation -->
<!-- The error below will be ignored -->
# Trailing punctuation!
<!-- markdownlint-enable no-trailing-punctuation -->

<!-- Will error -->
# Another trailing punctuation!

<!-- Will error -->
# Trailing punctuation again!
```
