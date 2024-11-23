#!/bin/bash
# Test basic file counting functionality

output=$($COMMAND "$PROJECT_ROOT/cltest/_test_input.txt")
if [ $? -ne 0 ]; then
    echo "Command failed to execute"
    exit 1
fi

# Extract values using awk to handle variable spacing
read lines words chars filename <<< $(echo "$output" | awk '{print $1, $2, $3, $4}')

# Check values with appropriate ranges
[ "$lines" -eq 4 ] || { echo "Expected 4 lines, got $lines"; exit 1; }
[ "$words" -ge 15 ] && [ "$words" -le 17 ] || { echo "Word count $words outside acceptable range 15-17"; exit 1; }
[ "$chars" -ge 70 ] || { echo "Character count $chars less than minimum 70"; exit 1; }

# Verify filename appears in output
echo "$output" | grep -q "$PROJECT_ROOT/cltest/_test_input.txt" || { echo "Filename missing from output"; exit 1; }
