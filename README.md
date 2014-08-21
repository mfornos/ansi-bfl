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

Here some screenshots from the demo script in the examples folder.

![Colors demo](https://raw.githubusercontent.com/mfornos/ansi-bfl/screenshots/colors-demo.jpg "Colors demo")

![Report demo](https://raw.githubusercontent.com/mfornos/ansi-bfl/screenshots/report-demo.jpg "Report demo")

How it feels?
-------------

*Coloured text*

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

*Headers*

```bash
ansi::heading "Heading 1"
```

```bash
ansi::title "Title 1" "*"
```

*Aligned text*

```bash
ansi::right "LOREM IPSUM"
```

```bash
ansi::left_right "Summary" "0.10 $(ansi::fg blue)YES$(ansi::reset)" 80
```

// EOF
