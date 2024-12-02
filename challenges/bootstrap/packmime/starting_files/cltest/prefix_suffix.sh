#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test" > input.txt

$COMMAND --prefix="START" --suffix="END" input.txt > out
tr -d '\r' < out > out.clean

# Check prefix and suffix
assert grep -q '^START$' out.clean
assert grep -q '^END$' out.clean

end_of_test
