#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Generate a large input file to test buffering behavior
perl -e 'print "a" x 1000000' > large_input.txt
$COMMAND 'a' 'b' < large_input.txt > output.txt
head -c 100 output.txt > sample.txt
if grep -q '[^b]' sample.txt; then
    echo "Found unexpected character in output" >&2
    exit 1
fi

# Test with multiple operations on large input
cat large_input.txt | $COMMAND -d -s 'a' > output2.txt
if [ -s output2.txt ]; then
    echo "Expected empty output file" >&2
    exit 1
fi
