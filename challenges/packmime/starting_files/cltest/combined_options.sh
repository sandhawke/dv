#!/bin/bash
mkdir test
echo "content" > test/file.txt
ln -s file.txt test/link.txt
output=$($COMMAND --preserve --mime-types --symlink-action=describe test)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Modified:"* ]] &&
  [[ "$output" == *"Content-Type:"* ]] &&
  [[ "$output" == *"symbolic link"* ]]
