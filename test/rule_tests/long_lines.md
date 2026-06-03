This is a very very very very very very very very very very very very very very long line {MD013}

This line however, while very long, doesn't have whitespace after the 80th columnwhichallowsforURLsandotherlongthings. {MD013}

[This is a markdown link whose text has spaces but the whole line is just the link](https://example.com/path) {MD013}

* [This is a list item whose only content is a markdown link](https://example.com/very/long/path/here) {MD013}

* verylongwordthatexceedsthelinelimitbecauseithasnospacesandistheentirelistitemcontent

1. [This is an ordered list item whose only content is a markdown link](https://example.com/path) {MD013}

1. verylongwordthatexceedsthelinelimitbecauseithasnospacesandistheentireorderedlistitem

* An item with a continuation line whose content is a single long word.
  This-is-a-very-long-word-that-does-not-fit-in-eighty-characters-and-will-trigger-lint-rule-violation

* An item whose continuation is a backtick-wrapped word.
  `a-big-long-word-herea-big-long-word-herea-big-long-word-herea-big-long-word-here`

* [Package Maintenance Guide](
  https://docs.fedoraproject.org/en-US/package-maintainers/Package_Maintenance_Guide/
  )
