This is a GFM-style fenced code block:

``` bash
#!/bin/bash

# Print something to stdout:
echo "Hello"
echo "World"
```

This is a kramdown-style fenced code block:

~~~ bash
#!/bin/bash

# Print something to stdout:
echo "Hello"
echo "World"
~~~

Code blocks with spaces in the info string should also be recognized:

```c hlines=2
#include <stdio.h>

int main() { return 0; }
```

~~~python hl_lines="1 2"
# a comment that looks like an ATX header
##also looks like a header
~~~

None of the above should trigger any heading related rules.

```
Code block without a language specifier
```

{MD040:36}
