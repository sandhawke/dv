#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test POSIX character classes
echo "hello123" | $COMMAND '[:digit:]' '0' > output.txt
assert_output "hello000" "$(cat output.txt)"
