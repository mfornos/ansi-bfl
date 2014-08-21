ANSI Bash Function Library
==========================

Bash functions for Terminals with ANSI support.

Features
--------

* Terminal modes
* Coloured text
* Titles and headings
* Text alignment and formatting
* Strip ANSI escape sequences
* Color conversions and aliases

How it looks?
-------------



How it feels?
-------------

Coloured text

```bash
ansi::fg red
echo Hello!
ansi::reset
```

```bash
echo "$(ansi::fg red)Hello!"
```

```bash
ansi::fg 2
echo Hello!
```

Headers

```bash
ansi::heading "Heading 1"
```

Aligned text

```bash
ansi::right "LOREM IPSUM"
```

// EOF