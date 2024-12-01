#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test" > input.txt

# Test LF option
$COMMAND --lf input.txt > out.lf
assert [ $(grep -c $'\r' out.lf) -eq 0 ]

# Test CR-LF option
$COMMAND --cr input.txt > out.crlf
assert [ $(grep -c $'\r\n' out.crlf) -gt 0 ]

end_of_test
