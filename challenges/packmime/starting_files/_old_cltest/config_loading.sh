#!/bin/bash
echo '{"defaults":{"maxFileBytes":100}}' > test.json
dd if=/dev/zero of=big.txt bs=200 count=1 2>/dev/null
output=$($COMMAND --config=test.json big.txt)
[ $? -eq 0 ] &&
  [[ "$output" == *"X-Truncation-Notice"* ]]
