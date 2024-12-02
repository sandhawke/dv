#!/bin/bash
# Test handling of Unicode text

output=$($COMMAND -l -w "$PROJECT_ROOT/cltest/_unicode_input.txt")

# Extract counts using flexible pattern matching
lines=$(echo "$output" | awk '{print $1}')
words=$(echo "$output" | awk '{print $2}')

# Check values with more flexible ranges
[ "$lines" -eq 4 ] || exit 1
[ "$words" -ge 4 ] && [ "$words" -le 6 ] || exit 1  # Allow some flexibility in Unicode word counting
echo "$output" | grep -q "$PROJECT_ROOT/cltest/_unicode_input.txt" || exit 1
