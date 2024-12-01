#!/bin/bash
source $(dirname $0)/_setup.sh

# Create a non-UTF8 binary file
printf '\xFF\xFE\x00\x00' > binary.dat

$COMMAND binary.dat > out

# Should automatically use base64 encoding
assert grep -q 'Content-Transfer-Encoding: base64' out

end_of_test
