#!/usr/bin/env bash
#
# ANSI lib demo.
# 

. ../ansi.sh

BASIC=(ansi::bold ansi::half_bright ansi::italics ansi::underline ansi::reverse)

function demo::title {
  echo; ansi::title "$1"; echo;
}

function demo::pt {
  ${1}; echo -en "$2"; ansi::reset; echo -n " "
}

function demo::cube {
  demo::title "8-bit Color Cube"

  local green red blue

  for green in {0..5}; do
    for red in {0..5}; do
      for blue in {0..5}; do
        let color="16 + ($red * 36) + ($green * 6) + $blue"
        ansi::bg $color
        echo -n " "
      done;
      ansi::reset
    done;
    echo
  done;
}

function demo::text {
  demo::title "Basic"

  for TT in ${BASIC[@]}; do
    demo::pt $TT "$TT"
  done
  echo

  demo::title "Colors"

  for SC in ${SYS_COLORS[@]}; do
    demo::pt "ansi::fg $SC" "$SC"
  done

  for SC in ${SYS_COLORS[@]}; do
    demo::pt "ansi::bg $SC" "$SC"
  done
  echo

  demo::title "Bright Colors"

  for SC in ${SYS_COLORS[@]}; do
    bright="bright_$SC"
    demo::pt "ansi::fg $bright" "b_$SC"
  done

  for SC in ${SYS_COLORS[@]}; do
    bright="bright_$SC"
    demo::pt "ansi::bg $bright" "b_$SC"
  done
  echo
}

function demo::banner {
  ansi::clear
  l=$(ansi::hline $COLUMNS '*')
  ansi::hcenter_print "$l" 0
  ansi::hcenter_print "$(ansi::reverse)- ANSI Demo -$(ansi::reset)" 1
  ansi::hcenter_print "$l" 2
  ansi::reset
}

function demo::success {
  ansi::left_right "$1" "[ $(ansi::fg green)SUCCESS$(ansi::reset) ]" 80 '.'
}

function demo::fail {
  ansi::left_right "$1" "[ $(ansi::fg red)FAIL$(ansi::reset)    ]" 80 '.'
}

function demo::report {
  ansi::right "[TEXT]"
  star="$(ansi::fg bright_red)\xe2\x98\x85$(ansi::reset)"
  demo::title "Cute Report"
  ansi::heading "$star AWESOME Report" 80 "$star"
  echo
  demo::success "How cute is this kitten?"
  demo::fail "Help needed determining sex of kitten"
  demo::success "Everything about kittens"
  ansi::hnline 80 '='
  ansi::left_right "$(ansi::bold)Summary$(ansi::reset)" "0.10 $(ansi::fg blue)YES$(ansi::reset)" 80
}

function demo {
  ansi::tput_installed || { echo "tput not found!" && exit -1; }
  ansi::colors_supported || echo "WARN: Your term supports less than 256 colors ($TERM)."

  demo::banner

  ansi::right "[COLORS]"
  demo::text
  demo::title "Rainbow"
  echo -e $(ansi::rainbow "Somewhere over the rainbow.")

  demo::cube

  demo::report

  ansi::right "[EOD]"
}

# Kick-off
demo

exit 0

