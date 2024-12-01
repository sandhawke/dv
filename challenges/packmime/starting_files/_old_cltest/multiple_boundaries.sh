#!/bin/bash
echo "--boundary-00" > file1.txt
echo "--boundary-01" > file2.txt
output=$($COMMAND file1.txt file2.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"boundary=\"boundary-02\""* ]]
