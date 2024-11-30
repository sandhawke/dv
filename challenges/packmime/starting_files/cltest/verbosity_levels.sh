#!/bin/bash
echo "test" > input.txt
$COMMAND --quiet input.txt >/dev/null 2>quiet.txt
$COMMAND --verbose=0 input.txt >/dev/null 2>v0.txt
$COMMAND --verbose=1 input.txt >/dev/null 2>v1.txt
$COMMAND --verbose=2 input.txt >/dev/null 2>v2.txt
$COMMAND -v input.txt >/dev/null 2>v.txt
$COMMAND -vv input.txt >/dev/null 2>vv.txt
$COMMAND -vvv input.txt >/dev/null 2>vvv.txt

# check them with cmp -s and wc -l
