#!/bin/bash
mkdir -p test/logs/system test/logs/app
echo "keep" > test/logs/app/important.log
echo "ignore" > test/logs/system/debug.log
echo "special" > test/logs/app/debug.log

output=$($COMMAND \
    --ignore="**/*.log" \
    --ignore="**/logs/**" \
    --unignore="**/important.log" \
    test)

[ $? -eq 0 ] &&
  [[ "$output" == *"important.log"* ]] &&
  [[ "$output" != *"system/debug.log"* ]] &&
  [[ "$output" != *"app/debug.log"* ]]
