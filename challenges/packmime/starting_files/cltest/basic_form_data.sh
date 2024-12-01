#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND name=value > out
tr -d '\r' < out > out.clean

assert grep -q 'Content-Type: multipart/mixed; boundary="boundary-00"' out.clean
assert grep -q 'Content-Disposition: form-data; name="name"' out.clean
assert grep -q '^value$' out.clean

end_of_test
