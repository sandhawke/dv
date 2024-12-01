#!/bin/bash
echo "target" > target.txt
ln -s target.txt link.txt
output=$($COMMAND --symlink-action=describe link.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"symbolic link"* ]]
