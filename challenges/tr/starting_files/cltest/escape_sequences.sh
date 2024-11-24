#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test escape sequences
# Using standard tr escape format \061 (octal)
echo "hello" | $COMMAND 'e' '\105' > output.txt
assert_output "hEllo" "$(cat output.txt)"
