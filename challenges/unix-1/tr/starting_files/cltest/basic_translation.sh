#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test basic character translation
echo "hello" | $COMMAND 'eo' 'EO' > output.txt
assert_output "hEllO" "$(cat output.txt)"
