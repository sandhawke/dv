#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND name=value > out

assert grep -q 'Content-Type: multipart/mixed; boundary="boundary-00"' out
assert grep -q 'Content-Disposition: form-data; name="name"' out
assert grep -q '^value$' out

end_of_test
