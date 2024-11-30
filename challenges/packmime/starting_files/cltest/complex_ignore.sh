#!/bin/bash
mkdir -p test/a/b test/c
touch test/a/1.txt test/a/b/2.txt test/c/3.txt
output=$($COMMAND --ignore="test/a/**" --unignore="**/2.txt" test)
[ $? -eq 0 ] &&
  [[ "$output" != *"1.txt"* ]] &&
  [[ "$output" == *"2.txt"* ]] &&
  [[ "$output" == *"3.txt"* ]]
