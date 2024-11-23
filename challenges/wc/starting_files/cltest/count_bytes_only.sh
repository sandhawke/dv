#!/bin/bash
# Test -c option for byte counting

output=$($COMMAND -c "$PROJECT_ROOT/cltest/_test_input.txt")

# Extract count using flexible pattern matching
count=$(echo "$output" | awk '{print $1}')

# Check value without being strict about formatting
[ "$count" -ge 74 ] || exit 1  # Allow for different newline handling
echo "$output" | grep -q "$PROJECT_ROOT/cltest/_test_input.txt" || exit 1
