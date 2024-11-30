#!/bin/bash
echo "test" > input.txt
quiet=$($COMMAND --quiet input.txt 2>&1)
verbose=$($COMMAND -vvv input.txt 2>&1)
[ $? -eq 0 ] &&
  [ -z "$quiet" ] &&
  [[ "$verbose" == *"Processing"* ]]
