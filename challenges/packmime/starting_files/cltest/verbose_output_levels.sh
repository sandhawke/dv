#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test" > input.txt

# Test quiet mode
$COMMAND --quiet input.txt 2> err.quiet
assert [ ! -s err.quiet ]

# Test verbose level 1 (default)
$COMMAND input.txt 2> err.v1
assert grep -q "parts.*bytes" err.v1

# Test verbose level 2
$COMMAND -v input.txt 2> err.v2
assert grep -q "part.*tokens" err.v2

end_of_test
