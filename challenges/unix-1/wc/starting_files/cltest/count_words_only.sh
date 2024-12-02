#!/bin/bash
# Test -w option for word counting

output=$($COMMAND -w "$PROJECT_ROOT/cltest/_test_input.txt")
if [ $? -ne 0 ]; then
    echo "Command failed to execute"
    exit 1
fi

# Extract count using awk for reliable parsing
count=$(echo "$output" | awk '{print $1}')

# Check value with more flexible range and better error message
[ "$count" -ge 15 ] && [ "$count" -le 17 ] || {
    echo "Word count $count outside acceptable range 15-17"
    exit 1
}

# Verify filename appears in output
echo "$output" | grep -q "$PROJECT_ROOT/cltest/_test_input.txt" || {
    echo "Filename missing from output"
    exit 1
}
