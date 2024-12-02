#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create file with only spaces and tabs
create_test_file "whitespace.txt" "   " "		" "  	  "

output=$($COMMAND whitespace.txt)
[ $? -eq 0 ] || exit 1

# Should have 3 lines, 0 words
read lines words chars _ <<< $(echo "$output" | awk '{print $1, $2, $3, $4}')
[ "$lines" -eq 3 ] || exit 1
[ "$words" -eq 0 ] || exit 1
