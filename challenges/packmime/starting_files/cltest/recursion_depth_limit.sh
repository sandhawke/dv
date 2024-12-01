#!/bin/bash
source $(dirname $0)/_setup.sh

# Create deep directory structure exactly at limit (32 levels)
dir="test"
for i in {1..32}; do
    dir="$dir/subdir"
    mkdir -p "$dir"
done
echo "deep file" "$dir/file.txt"

# This should succeed
$COMMAND test > out.ok

# Now add one more level to exceed limit
mkdir -p "$dir/subdir"
echo "too deep" > "$dir/subdir/file.txt"

# This should fail with recursion depth error
if $COMMAND test 2> err.fail; then
    assert false
fi
assert grep -q "recur" err.fail

end_of_test
