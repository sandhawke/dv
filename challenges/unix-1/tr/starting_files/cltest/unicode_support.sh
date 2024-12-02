#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test basic ASCII character translation
# Note: Standard tr primarily handles single-byte characters
echo "hello" | $COMMAND 'l' 'L' > output.txt
assert_output "heLLo" "$(cat output.txt)"
