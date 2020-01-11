The following code block shouldn't have $ before the commands:

```bash
$ ls
$ less foo

$ cat bar
```

However the following code block shows output, and $ can be used to
distinguish between command and output:

```bash
$ ls
foo bar
$ less foo
Hello world

$ cat bar
baz
```

The following code block uses variable names, and likewise shouldn't fire:

```bash
$foo = 'bar';
$baz = 'qux';
```

The following code block doesn't have any dollar signs, and shouldn't fire:

```bash
ls foo
cat bar
```

The following (fenced) code block doesn't have any content at all, and
shouldn't fire:

```bash
```

{MD014:3}
