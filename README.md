ANSI Bash Function Library
==========================

Bash functions for Terminals with ANSI support.

Features
--------

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

__Coloured text__

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

__Headers__

```bash
ansi::heading "Heading 1"
```

```bash
ansi::title "Title 1" "*"
```

__Aligned text__

```bash
ansi::right "LOREM IPSUM"
```

```bash
ansi::left_right "Summary" "0.10 $(ansi::fg blue)YES$(ansi::reset)" 80
```

How it works?
-------------

On most typical terminals and operating systems *ANSI Bash Function Library* should works out of the box, if you don't see any colors or the output is not exacthly what you expect, you probaly have a terminal type that doesn't handle all the ANSI terminal codes used by **ansi-bfl**.

On some Linux, FreeBSD or OpenBSD terminal you could try to set

```sh
TERM=xterm-256color
```
On AIX and Solaris you can try with
```
TERM=dtterm
```
Reading the *terminfo*, *termcap* and *term* manual pages will help you to find out the terminal type you should set.

// EOF
