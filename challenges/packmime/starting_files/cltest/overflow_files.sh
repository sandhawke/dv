#!/bin/bash
dd if=/dev/zero of=big.txt bs=1024 count=100 2>/dev/null
$COMMAND --context=100 big.txt
[ $? -eq 0 ] &&
  [ -f "packmime-overflow.$$.000001.mime" ]
