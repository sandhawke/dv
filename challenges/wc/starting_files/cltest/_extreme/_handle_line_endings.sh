#!/bin/bash
source "$PROJECT_ROOT/cltest/_setup.sh"

# Create files with different line endings
printf "line1\r\nline2\r\nline3\r\n" > crlf.txt
printf "line1\rline2\rline3\r" > cr.txt
printf "line1\nline2\nline3\n" > lf.txt

# Test each file
for file in crlf.txt cr.txt lf.txt; do
    output=$($COMMAND -l "$file")
    [ $? -eq 0 ] || exit 1

    # Each should show 3 lines
    count=$(echo "$output" | awk '{print $1}')
    [ "$count" -eq 3 ] || exit 1
done
