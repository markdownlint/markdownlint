# Regular header

<h1>Inline HTML Header {MD033}</h1>

<p>More inline HTML {MD033}
but this time on multiple lines
</p>

    <h1>This shouldn't trigger as it's inside a code block</h1>

```text
<p>Neither should this as it's also in a code block</p>
```

The rule has been customized to allow some elements while disallowing
everything else.

Test case for the line break element<br>
present on `allowed_elements` and it should be permitted.
