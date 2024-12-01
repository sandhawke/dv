#!/bin/bash
source $(dirname $0)/_setup.sh

# Create files of different types
echo "text" > test.txt
printf "\x89PNG\x0D\x0A\x1A\x0A" > test.png

$COMMAND --mime-types test.txt test.png > out

# Check Content-Type headers
assert grep -q 'Content-Type: text/plain' out
assert grep -q 'Content-Type: image/png' out

end_of_test
