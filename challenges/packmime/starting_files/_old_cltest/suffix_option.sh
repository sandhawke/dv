#!/bin/bash
echo "test" > input.txt
output=$($COMMAND --suffix="SUFFIX" input.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"SUFFIX" ]]
