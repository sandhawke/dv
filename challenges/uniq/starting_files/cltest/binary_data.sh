#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create test files with some non-printing characters (using printf)
printf "abc\001\n"  > input.txt
printf "abc\001\n"  >> input.txt
printf "def\002\n"  >> input.txt
printf "def\002\n"  >> input.txt

# Create expected output
printf "abc\001\n"  > expected.txt
printf "def\002\n"  >> expected.txt

# Run uniq
$COMMAND input.txt > output.txt

# Compare output with expected
compare_files output.txt expected.txt
