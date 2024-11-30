#!/bin/bash
echo -ne '\xFF\xFE' > invalid.txt
output=$($COMMAND invalid.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Transfer-Encoding: base64"* ]]
