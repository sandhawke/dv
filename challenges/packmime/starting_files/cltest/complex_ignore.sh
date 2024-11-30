#!/bin/bash
mkdir -p test/src/cache test/build test/logs
touch test/src/file.js test/src/cache/temp.js test/build/output.js test/logs/error.log
echo "important" > test/logs/important.log

output=$($COMMAND \
    --ignore="**/cache/**" \
    --ignore="build/" \
    --ignore="**/*.log" \
    --unignore="**/important.log" \
    test)

[ $? -eq 0 ] &&
  [[ "$output" == *"file.js"* ]] &&
  [[ "$output" != *"temp.js"* ]] &&
  [[ "$output" != *"output.js"* ]] &&
  [[ "$output" != *"error.log"* ]] &&
  [[ "$output" == *"important.log"* ]]
