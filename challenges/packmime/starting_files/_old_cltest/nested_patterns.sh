#!/bin/bash
mkdir -p test/a/b/c test/d/e/f
touch test/a/1.txt test/a/b/2.txt test/a/b/c/3.txt
touch test/d/4.txt test/d/e/5.txt test/d/e/f/6.txt

output=$($COMMAND \
    --ignore="test/a/**" \
    --ignore="test/d/e/**" \
    --unignore="**/c/*.txt" \
    test)

[ $? -eq 0 ] &&
  [[ "$output" != *"1.txt"* ]] &&
  [[ "$output" != *"2.txt"* ]] &&
  [[ "$output" == *"3.txt"* ]] &&
  [[ "$output" == *"4.txt"* ]] &&
  [[ "$output" != *"5.txt"* ]] &&
  [[ "$output" != *"6.txt"* ]]
