#!/usr/bin/env bash
#
# Bash functions for Terminals with ANSI support.
# 

# ====================================================
# System colors
# ====================================================
black=0;    bright_black=8
red=1;      bright_red=9
green=2;    bright_green=10
yellow=3;   bright_yellow=11
blue=4;     bright_blue=12
magenta=5;  bright_magenta=13
cyan=6;     bright_cyan=14
white=7;    bright_white=15

SYS_COLORS=(black red green yellow blue magenta cyan white)


# ====================================================
# ANSI lib
# ====================================================

##
# Checks the supported number of colors
#
# Arguments
#    - 1: ncolors (opt)
#        num. of colors required, defaults to 256
#
# Return
#    0 if ncolors are supported, -1 otherwise
#
function ansi::colors_supported {
  local ncolors=$(tput colors)
  if [ "$ncolors" -lt ${1:-256} ]; then return -1; fi
  return 0
}

##
# Checks if tput is installed
#
# Return
#    0 if tput is found, -1 otherwise
#
function ansi::tput_installed {
  command -v tput >/dev/null 2>&1 || return -1;
  return 0
}

##
# Prints an horizontal line
#
# Arguments
#    - 1: line length (opt)
#        defaults to current terminal columns
#    - 2: separator (opt)
#        supports unicode and ansi, defaults to '-'
#
function ansi::hline {
  local hl="$(printf '%*s' ${1:-$COLUMNS} '')"
  echo -ne "${hl// /${2:--}}"
}


##
# Prints an horizontal line with carriage return at the end
#
# Arguments
#    - 1: line length (opt)
#        defaults to current terminal columns
#    - 2: separator (opt)
#        supports unicode and ansi, defaults to '-'
#
function ansi::hnline {
  ansi::hline "$@"; echo;
}

##
# Prints a text surrounded by horizontal lines
#
# Arguments
#    - 1: text
#    - 2: line length (opt)
#        defaults to current terminal columns
#    - 3: separator (opt)
#        supports unicode and ansi, defaults to '-'
#
function ansi::heading {
  ansi::hnline $2 "$3";
  echo -e "$1"
  ansi::hnline $2 "$3";
}

##
# Prints a text followed by a line of the same length
#
# Arguments
#    - 1: text
#    - 2: separator (opt)
#        supports unicode and ansi, defaults to '-'
#    - 3: line length (opt)
#        defaults to text length
#
function ansi::title {
  echo -e "$1"
  ansi::hnline ${3:-${#1}} "${2:--}"
}

##
# Strips ANSI escape sequences
#
# Arguments
#    - 1: text
#
# Return
#    text without ANSI escapes
#
function ansi::strip {
  local tmp="$1"
  local esc=$(printf "\x1b")
  local tpa=$(printf "\x28")
  local re="(.*)$esc[\[$tpa][0-9]*;*[mKB](.*)"
  while [[ $tmp =~ $re ]]; do
    tmp=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
  done
  echo "$tmp"
}

#
# Text alignment
# ----------------------------------------------------
COLUMNS=$(tput cols)
LINES=$(tput lines)
VCENTER=$(( $LINES / 2 ))

##
# Moves the cursor
#
# Arguments
#    - 1: text offset
#        text to be counted as horizontal offset
#    - 2: column coordinate (opt)
#        defaults to vertical center
#    - 3_ line coordinate (opt)
#        defaults to horizontal center, according to text
#
function ansi::cursor_to {
  local x=${2:-$VCENTER}
  local y=${3:-$(( ($COLUMNS - ${#1}) / 2 ))}
  tput cup $x $y
}

##
# Centers cursor horizontally
#
# Arguments
#    - 1: text offset
#        text to be counted as horizontal offset
#    - 2: column coordinate
#
function ansi::hcenter {
  local txt=$(ansi::strip "$1")
  local y=$(( ($COLUMNS - ${#txt}) / 2 ))
  tput cup $2 $y
}

##
# Centers cursor horizontally and prints the given text
#
# Arguments
#    - 1: text
#        text to be counted as horizontal offset
#    - 2: column coordinate
#
function ansi::hcenter_print {
  ansi::hcenter "$1" $2
  echo -e "$1"
}

##
# Prints a line connecting between two symmetrically aligned
# texts
#
# Arguments
#    - 1: left text
#        text to be counted as offset
#    - 2: right text
#        text to be counted as offset
#    - 3: line length (opt)
#        defaults to current terminal columns
#    - 4: separator (opt)
#        supports unicode and ansi, defaults to space char
#
function ansi::lrl {
  local y=$(( ${3:-$COLUMNS} - (${#1} + ${#2}) ))
  ansi::hline $y "${4:- }"
}

##
# Prints two symmetrically aligned texts
#
# Arguments
#    - 1: left text
#        text to be counted as offset
#    - 2: right text
#        text to be counted as offset
#    - 3: line length (opt)
#        defaults to current terminal columns
#    - 4: separator (opt)
#        supports unicode and ansi, defaults to space char
#
function ansi::left_right {
  local left=$(ansi::strip "$1")
  local right=$(ansi::strip "$2")
  echo -en "$1"
  ansi::lrl "$left" "$right" ${3:-$COLUMNS} "${4:- }"
  echo -e "$2"
}

function ansi::right {
  ansi::left_right '' "$1"
}

#
# Color utils
# ----------------------------------------------------
CF=6/256
RAINBOW_COLORS=(red yellow green blue magenta)

##
# Converts an RGB color to its closest 8-bit equivalent
#
# Arguments
#    - 1: red 
#       0-255 number
#    - 2: green 
#       0-255 number
#    - 3: blue
#       0-255 number
#
# Return
#    0-255 value for its 8-bit representation
#
function ansi::rgb_conv {
  echo $(( 16 + (($1 * $CF) * 36) + (($2 * $CF) * 6) + ($3 * $CF) ))
}

##
# Resolves an ANSI color literal, if needed
#
# Arguments
#    - 1: color 
#       0-255 number or literal name
#
function ansi::color {
  local num=$1
  local re='^[0-9]+$'
  if ! [[ $num =~ $re ]]; then num="${!1}"; fi
  echo $num
}

##
# Fluffy rainbow printing
#
# Arguments
#    - 1: text
#
function ansi::rainbow {
  local str=''
  for (( i=0; i<${#1}; i++ )); do
    ch=${1:$i:1}
    co=${RAINBOW_COLORS[$((${i}%${#RAINBOW_COLORS[*]}))]}
    str+="$(ansi::fg $co)$ch$(ansi::reset)"
  done
  echo -en "$str"
}

# ====================================================
# Tput sugar - Terminfo commands and modes
# ====================================================

##
# Sets a foreground color.
#
# For system colors you can use the color names.
# v.g.  'fg red'
#
# Arguments
#    - 1: color 
#       0-255 number or literal name
#
function ansi::fg {
  tput "setaf" $(ansi::color $1)
}

##
# Sets a background color
#
# Arguments
#    - 1: color 
#       0-255 number or literal name
#
function ansi::bg {
  tput "setab" $(ansi::color $1)
}

##
# Enables bold text
#
function ansi::bold {
  tput "bold"
}

##
# Enables blinking text
#
function ansi::blink {
  tput "blink"
}

##
# Enables reverse video mode
#
function ansi::reverse {
  tput "rev"
}

##
# Enables underline
#
function ansi::underline {
  tput "smul"
}

##
# Disables underline
#
function ansi::end_underline {
  tput "rmul"
}

##
# Enables half bright mode
#
function ansi::half_bright {
  tput "dim"
}

##
# Enables italics
#
function ansi::italics {
  tput "sitm"
}

##
# Disables italics
#
function ansi::end_italics {
  tput "ritm"
}

##
# Triggers terminal bell
#
function ansi::bell {
  tput "bel"
}

##
# Flashes the terminal visual bell
#
function ansi::flash {
  tput "flash"
}

##
# Clears the terminal screen
#
function ansi::clear {
  tput "clear"
}

##
# Resets all term modes.
# Typically used to end previous escape sequences.
# v.g.
#  'ansi::fg 230; echo hi!; ansi::reset; echo ho!;'
#  'echo "$(ansi::fg 230)hi!$(ansi::reset) ho!"'
#
function ansi::reset {
  tput "sgr0"
}

# EOF
