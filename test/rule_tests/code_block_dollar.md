The following code block shouldn't have $ before the commands:

    $ ls {MD014}
    $ less foo

    $ cat bar

However the following code block shows output, and $ can be used to
distinguish between command and output:

    $ ls
    foo bar
    $ less foo
    Hello world

    $ cat bar
    baz