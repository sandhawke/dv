#!/bin/bash
source $(dirname $0)/_setup.sh

# Create complex directory structure
for dir in test/{a,b}/{1,2}/{x,y}; do
    mkdir -p "$dir" || exit 1
    echo "content" > "$dir/file.txt" || exit 1
done

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
