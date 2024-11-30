#!/bin/bash
echo -ne '\xFF\xFF' > binary.dat
output=$($COMMAND binary.dat)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Transfer-Encoding: base64"* ]]
