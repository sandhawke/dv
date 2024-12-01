#!/bin/bash
source $(dirname $0)/_setup.sh

mkdir -p test/subdir
echo "file1" > test/a.txt
echo "file2" > test/b.txt
echo "file3" > test/subdir/c.txt

$COMMAND test > out

# Should have all three files in codepoint order
assert grep -q 'filename="test/a.txt"' out
assert grep -q 'filename="test/b.txt"' out
assert grep -q 'filename="test/subdir/c.txt"' out

# Check content is preserved
assert grep -q '^file1$' out
assert grep -q '^file2$' out
assert grep -q '^file3$' out

end_of_test
