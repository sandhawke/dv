#!/bin/bash
mkdir test
echo "keep" > test/keep.txt
echo "ignore" > test/ignore.txt
output=$($COMMAND --ignore="*ignore.txt" test)
[ $? -eq 0 ] &&
  [[ "$output" == *"keep.txt"* ]] &&
  [[ "$output" != *"ignore.txt"* ]]
