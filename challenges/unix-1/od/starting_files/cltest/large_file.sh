#!/bin/bash
source "${PROJECT_ROOT}/cltest/_common.sh"

# Create a 1MB file
dd if=/dev/zero of=large.bin bs=1M count=1 2>/dev/null

# Test processing of large file
# Just check beginning and end format
first_line=$($COMMAND large.bin | head -n 1)
last_line=$($COMMAND large.bin | tail -n 1)

# Check first line shows all zeros
if ! echo "$first_line" | grep -q "^0000000 000000 000000 000000 000000"; then
    echo "First line should show zeros"
    echo "Got: $first_line"
    exit 1
fi

# Check last line shows offset (4000000 octal for 1MB)
if [ "$last_line" != "4000000" ]; then
    echo "Last line should show 4000000"
    echo "Got: $last_line"
    exit 1
fi
