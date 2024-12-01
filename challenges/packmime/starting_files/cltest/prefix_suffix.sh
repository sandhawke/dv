#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test" > input.txt

$COMMAND --prefix="START" --suffix="END" input.txt > out

# Check prefix and suffix
assert grep -q '^START$' out
assert grep -q '^END$' out

end_of_test
