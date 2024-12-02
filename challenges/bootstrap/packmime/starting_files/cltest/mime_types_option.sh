#!/bin/bash
source $(dirname $0)/_setup.sh

# Create sample files
echo "text" > test.txt
dd if=/dev/urandom of=test.png bs=1024 count=1 2>/dev/null

$COMMAND --mime-types test.txt test.png > out

# Check Content-Type headers
assert grep -q 'Content-Type: text/plain' out
assert grep -q 'Content-Type: image/png' out
assert grep -q 'Content-Transfer-Encoding: base64' out

end_of_test
