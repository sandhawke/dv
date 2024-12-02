#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND --help > out

assert grep -q 'Usage:' out
assert grep -q '\[options\]' out
assert grep -q '\[terms\]' out

end_of_test
