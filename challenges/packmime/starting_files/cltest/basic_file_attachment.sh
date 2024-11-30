#!/bin/bash
echo "test content" > input.txt
output=$($COMMAND input.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Type: multipart/mixed; boundary=\"boundary-00\""* ]] &&
  [[ "$output" == *"Content-Disposition: attachment; filename=\"input.txt\""* ]] &&
  [[ "$output" == *"test content"* ]]
