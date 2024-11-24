#!/bin/bash

. "$PROJECT_ROOT/cltest/_common.sh"

# Create file with extremely long lines
for i in {1..10}; do
    printf 'x%.0s' {1..1000000} >> "long_input.txt"
    echo >> "long_input.txt"
done

# Run uniq on very long lines
$COMMAND long_input.txt > "output.txt"

# Verify processing completed
[ -s "output.txt" ]
