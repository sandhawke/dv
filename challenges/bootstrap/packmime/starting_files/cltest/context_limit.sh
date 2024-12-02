#!/bin/bash
source $(dirname $0)/_setup.sh

# Create files that will exceed context limit
echo "file1 content" > file1.txt
echo "file2 content" > file2.txt

$COMMAND --context=1 file1.txt file2.txt > out

# Check first file went to stdout
assert grep -q 'file1 content' out

# Check overflow file was created and contains second file
assert ls packmime-overflow.*.000001.mime
assert grep -q 'file2 content' packmime-overflow.*.000001.mime

end_of_test
