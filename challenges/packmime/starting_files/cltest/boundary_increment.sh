#!/bin/bash
source $(dirname $0)/_setup.sh

# Create file containing the default boundary
echo "--boundary-00" > input.txt

$COMMAND input.txt > out

# Should use an incremented boundary
assert grep -q 'boundary="boundary-01"' out
assert grep -q '^--boundary-00$' out

end_of_test
