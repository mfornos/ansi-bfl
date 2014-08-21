ANSI Bash Function Library
==========================

Bash functions for Terminals with ANSI support.

Features
--------

* Terminal modes
* ANSI colors
* Titles and headings
* Text alignment and formatting
* Strip ANSI escape sequences
* Color conversions and aliases

How it looks?
-------------



How it feels?
-------------

Printing red text

```bash
ansi::fg red
echo Hello!
ansi::reset
```

or

```bash
echo "$(ansi::fg red)Hello!"
```

or

```bash
ansi::fg 2
echo Hello!
```

Printing a heading

```bash
ansi::heading "Heading 1"
```

Printing right aligned text

```bash
ansi::right "LOREM IPSUM"
```
