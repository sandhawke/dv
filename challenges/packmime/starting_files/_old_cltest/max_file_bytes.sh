#!/bin/bash
dd if=/dev/zero of=large.txt bs=1024 count=20 2>/dev/null
output=$($COMMAND --max-file-bytes=1024 large.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"X-Truncation-Notice"* ]]
