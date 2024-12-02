#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test basic space translation
printf "hello  world" | $COMMAND ' ' '_' > output1.txt
assert_output "hello__world" "$(cat output1.txt)"

# Test space class translation
printf "hello  world\ttest" | $COMMAND '[:space:]' '_' > output2.txt
assert_output "hello__world_test" "$(cat output2.txt)"

# Test squeezing spaces
printf "hello   world\t\ttest" | $COMMAND -s '[:space:]' ' ' > output3.txt
assert_output "hello world test" "$(cat output3.txt)"
