#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test content" > input.txt

$COMMAND input.txt > out

assert grep -q 'Content-Type: multipart/mixed; boundary="boundary-00"' out
assert grep -q 'Content-Disposition: attachment; filename="input.txt"' out
assert grep -q 'test content' out
assert grep -q '^--boundary-00--$' out

end_of_test
