#!/bin/bash
mkdir -p test
echo "keep" > test/keep.txt
echo "special" > test/ignore-but-keep.txt
output=$($COMMAND --ignore="*ignore*" --unignore="*keep.txt" test)
[ $? -eq 0 ] &&
  [[ "$output" == *"ignore-but-keep.txt"* ]]
