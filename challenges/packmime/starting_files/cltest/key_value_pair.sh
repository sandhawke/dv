#!/bin/bash
output=$($COMMAND name=value)
[ $? -eq 0 ] &&
  [[ "$output" == *"Content-Type: multipart/mixed; boundary=\"boundary-00\""* ]] &&
  [[ "$output" == *"Content-Disposition: form-data; name=\"name\""* ]] &&
  [[ "$output" == *"value"* ]]
