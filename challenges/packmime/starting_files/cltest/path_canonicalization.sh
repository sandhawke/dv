#!/bin/bash
source $(dirname $0)/_setup.sh

# Create test directory structure
mkdir -p test/sub
echo "content" > test/sub/file.txt

# Test various path formats
$COMMAND ./test/sub/../sub/./file.txt > out
assert grep -q 'filename="test/sub/file.txt"' out

# Test absolute path
$COMMAND "$(pwd)/test/sub/file.txt" > out
assert grep -q 'filename="test/sub/file.txt"' out

# Test path warning
$COMMAND ../outside.txt 2> err || true
assert grep -q "above current working directory" err

end_of_test
