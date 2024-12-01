#!/bin/bash
source $(dirname $0)/_setup.sh

# Test empty file
touch empty.txt
$COMMAND empty.txt > out.empty
assert [ -s out.empty ]

# Test non-existent file
$COMMAND nonexistent.txt 2> err.missing
assert [ $? -ne 0 ]
assert grep -q "not exist" err.missing

# Test special prefix/suffix characters
$COMMAND --prefix=$'*\n\r\t' --suffix=$'$\n\r\t' input.txt > out.special
tr -d '\r' < out.special > out.special.clean
assert grep -q $'^\*$' out.special.clean
assert grep -q $'^\$$' out.special.clean

end_of_test
