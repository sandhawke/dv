#!/bin/bash
mkdir -p test/subdir
echo "file1" > test/a.txt
echo "file2" > test/b.txt
echo "file3" > test/subdir/c.txt
output=$($COMMAND test)
[ $? -eq 0 ] &&
  [[ "$output" == *"filename=\"test/a.txt\""* ]] &&
  [[ "$output" == *"filename=\"test/b.txt\""* ]] &&
  [[ "$output" == *"filename=\"test/subdir/c.txt\""* ]]
