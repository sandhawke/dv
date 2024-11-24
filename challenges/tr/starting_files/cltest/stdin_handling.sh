#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test handling of stdin as input
echo "hello" > input.txt
cat input.txt | $COMMAND 'el' 'EL' > output.txt
assert_output "hELLo" "$(cat output.txt)"
