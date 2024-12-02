#!/bin/bash

# Test --help option shows usage information
output=$($COMMAND --help)

# Check that help output contains essential information
echo "$output" | grep -q "Usage"
if [ $? -ne 0 ]; then
    echo "Help output missing usage information"
    exit 1
fi

# Should exit successfully after showing help
$COMMAND --help
exit $?
