#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test control characters (using actual ASCII control characters)
printf "hello" | $COMMAND '\010' 'x' > output1.txt
assert_output "xello" "$(cat output1.txt)"

# Test newline handling
printf "hello\nworld" | $COMMAND '\012' '#' > output2.txt
assert_output "hello#world" "$(cat output2.txt)"
