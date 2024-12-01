#!/bin/bash
source $(dirname $0)/_setup.sh

# Create deep directory structure exactly at limit (32 levels)
dir="test"
for i in {1..32}; do
    dir="$dir/subdir"
    mkdir -p "$dir"
    echo "level $i" > "$dir/file.txt"
done

# This should succeed
$COMMAND test > out.ok
assert [ $? -eq 0 ]

# Now add one more level to exceed limit
mkdir -p "$dir/subdir"
echo "too deep" > "$dir/subdir/file.txt"

# This should fail with recursion depth error
$COMMAND test 2> err.fail
assert [ $? -ne 0 ]
assert grep -q "recursion.*32" err.fail

end_of_test
