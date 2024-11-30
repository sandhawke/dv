#!/bin/bash
echo "--boundary-00" > conflict.txt
output=$($COMMAND conflict.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"boundary=\"boundary-01\""* ]]
