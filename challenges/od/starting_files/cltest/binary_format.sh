#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Test binary output format
create_test_file "input.bin"

output=$($COMMAND -b input.bin)
expected="0000000 000 001 002 003 004 005 006 007 010 011 012 013 014 015 016 017
0000020"

assert_output "$expected" "$output"
