#!/bin/bash
echo "test" > input.txt
output=$($COMMAND --prefix="PREFIX" input.txt)
[ $? -eq 0 ] &&
  [[ "$output" == "PREFIX"* ]]
