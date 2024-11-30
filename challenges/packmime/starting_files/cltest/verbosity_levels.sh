#!/bin/bash
echo "test" > input.txt
$COMMAND --quiet input.txt >/dev/null 2>quiet.txt
$COMMAND --verbose=0 input.txt >/dev/null 2>v0.txt
$COMMAND --verbose=1 input.txt >/dev/null 2>v1.txt
$COMMAND --verbose=2 input.txt >/dev/null 2>v2.txt
$COMMAND -v input.txt >/dev/null 2>v.txt
$COMMAND -vv input.txt >/dev/null 2>vv.txt
$COMMAND -vvv input.txt >/dev/null 2>vvv.txt

# Check that quiet and v0 produce no output
[ ! -s quiet.txt ] && [ ! -s v0.txt ] &&
# v1 should have summary line only
[ $(wc -l < v1.txt) -eq 1 ] &&
# v2 (-v) should have more lines than v1
[ $(wc -l < v2.txt) -gt $(wc -l < v1.txt) ] &&
# v2 and -v should be identical
cmp -s v2.txt v.txt &&
# v3 (-vv) should have more lines than v2
[ $(wc -l < vv.txt) -gt $(wc -l < v2.txt) ] &&
# v4 (-vvv) should have most lines
[ $(wc -l < vvv.txt) -gt $(wc -l < vv.txt) ] &&
