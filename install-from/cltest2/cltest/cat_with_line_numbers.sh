#!/bin/bash
source $(dirname $0)/_setup.sh

cat <<"_END" > input
1
2
3
_END

$COMMAND -n input > out

cat <<"_END" > expected
 1 1
 2 2
 3 3
_END

# use -b since whitespace isn't specified
assert diff -b expected out

end_of_test
