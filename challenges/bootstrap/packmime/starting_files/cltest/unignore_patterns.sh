#!/bin/bash
source $(dirname $0)/_setup.sh

mkdir -p test/logs
echo "keep" > test/logs/important.log
echo "ignore" > test/logs/other.log

$COMMAND --ignore="*.log" --unignore="*important.log" test > out

assert grep -q 'filename="test/logs/important.log"' out
assert ! grep -q 'filename="test/logs/other.log"' out

end_of_test
