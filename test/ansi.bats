#!/usr/bin/env bats

load $BATS_TEST_DIRNAME/../lib/ansi.sh

@test "strip ANSI" {
  txt="$(ansi::fg 2)Hi$(ansi::reset)"
  result="$(ansi::strip $txt)"
  [ ${#txt} -eq 13 ]
  [ ${#result} -eq 2 ]
}

@test "color names" {
  green="$(ansi::color green)"
  cyan="$(ansi::color 6)"
  [ $green -eq 2 ]
  [ $cyan -eq 6 ]
}

@test "rgb convert" {
  c="$(ansi::rgb_conv 255 10 0)"
  [ $c -eq 196 ]
}

@test "horizontal line" {
  result="$(ansi::hline 5 '-')"
  [ "$result" == '-----' ]
}

@test "horizontal new line" {
  result="$(ansi::hnline 5 '-' | tr '\n' 'N')"
  [ "$result" == '-----N' ]
}

@test "heading" {
  result="$(ansi::heading 'hi ho!' | tr '\n' 'N')"
  [[ "$result" =~ "Nhi ho!N" ]]
}

@test "title" {
  result="$(ansi::title 'hi ho!' | tr '\n' 'N')"
  [ "$result" == "hi ho!N------N" ]
}

# EOF
