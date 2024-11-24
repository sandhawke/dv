#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test multiple character classes in combination
echo "Hello123 World456!" | $COMMAND '[:alpha:][:digit:]' 'X' > output1.txt
# Only letters and digits are replaced, spaces and punctuation remain
assert_output "XXXXXXXX XXXXXXXX!" "$(cat output1.txt)"

# Test character class with complement
echo "Hello123 World456!" | $COMMAND -c '[:alpha:]' 'X' > output2.txt
# All non-letters (digits, spaces, punctuation) are replaced
assert_output "HelloXXXXWorldXXXXX" "$(cat output2.txt)"
