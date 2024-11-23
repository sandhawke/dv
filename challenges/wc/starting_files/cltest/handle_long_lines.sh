#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create file with a very long line
long_line=$(printf 'a%.0s' {1..10000})
create_test_file "longline.txt" "$long_line"

output=$($COMMAND longline.txt)
[ $? -eq 0 ] || exit 1

# Should have 1 line, 1 word
read lines words _ <<< $(echo "$output" | awk '{print $1, $2}')
[ "$lines" -eq 1 ] || exit 1
[ "$words" -eq 1 ] || exit 1
