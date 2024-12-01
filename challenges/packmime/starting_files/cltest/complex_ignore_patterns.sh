#!/bin/bash
source $(dirname $0)/_setup.sh

# Create complex directory structure
mkdir -p test/{a,b}/{1,2}/{x,y}
echo "content" > test/a/1/x/file.txt
echo "content" > test/a/1/y/file.txt
echo "content" > test/a/2/x/file.txt
echo "content" > test/b/1/y/file.txt

# Test complex pattern combinations
$COMMAND \
    --ignore="**/x/**" \
    --ignore="test/b/**" \
    --unignore="**/b/1/y/**" \
    test > out

# Should only include specific paths
assert grep -q 'test/a/1/y/file.txt' out
assert grep -q 'test/b/1/y/file.txt' out
assert ! grep -q 'test/a/1/x/file.txt' out
assert ! grep -q 'test/a/2/x/file.txt' out

end_of_test
