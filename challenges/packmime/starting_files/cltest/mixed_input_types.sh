#!/bin/bash
source $(dirname $0)/_setup.sh

# Create test files and directories
mkdir -p test/sub
echo "file1" > test/file1.txt
echo "file2" > test/sub/file2.txt

# Test with mixed input types
$COMMAND test key1=value1 extra.txt=file3 > out

# Check form-data
assert grep -q 'Content-Disposition: form-data; name="key1"' out
assert grep -q '^value1$' out

# Check directory contents
assert grep -q 'filename="test/file1.txt"' out
assert grep -q 'filename="test/sub/file2.txt"' out

# Check direct file assignment
assert grep -q 'filename="extra.txt"' out
assert grep -q '^file3$' out

end_of_test