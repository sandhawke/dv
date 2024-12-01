#!/bin/bash
source $(dirname $0)/_setup.sh

# Create deep directory structure
dir="test"
for i in {1..33}; do
    dir="$dir/subdir"
    mkdir -p "$dir"
    echo "level $i" > "$dir/file.txt"
done

$COMMAND test 2> err

# Should fail with recursion depth error
assert [ $? -ne 0 ]
assert grep -q "recursion.*32" err

end_of_test
