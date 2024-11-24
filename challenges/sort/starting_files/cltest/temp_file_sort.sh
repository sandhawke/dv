#!/bin/bash
. "$PROJECT_ROOT/cltest/_common.sh"

# Test sorting with temporary file (generate large input)
{
    for i in {1..1000}; do
        echo "Line $RANDOM"
    done
} > "large_input.txt"

# Sort with small buffer to force temp file usage
$COMMAND --buffer-size=1K large_input.txt > "output.txt"

# Verify output is sorted
if ! $COMMAND -c output.txt; then
    echo "Output file is not properly sorted"
    exit 1
fi
