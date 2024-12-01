#!/bin/bash
echo "test" > input.txt
output=$($COMMAND --preserve input.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Modified:"* ]]
