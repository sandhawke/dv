#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test content" > input.txt

$COMMAND input.txt > out
tr -d '\r' < out > out.clean

assert grep -q 'Content-Type: multipart/mixed; boundary="boundary-00"' out.clean
assert grep -q 'Content-Disposition: attachment; filename="input.txt"' out.clean
assert grep -q 'test content' out.clean
assert grep -q '^--boundary-00--$' out.clean

end_of_test
