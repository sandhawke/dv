#!/bin/bash
source $(dirname $0)/_setup.sh

mkdir -p test
echo "keep" > test/keep.txt
echo "ignore" > test/ignore.txt

$COMMAND --ignore="*ignore.txt" test > out

assert grep -q 'filename="test/keep.txt"' out
assert ! grep -q 'filename="test/ignore.txt"' out

end_of_test
