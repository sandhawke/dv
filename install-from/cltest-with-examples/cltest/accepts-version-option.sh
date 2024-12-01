#!/bin/bash
source $(dirname $0)/_setup.sh

# This is a good test to see if the command can execute at all.
# If it fails this, the program probably isn't running at all,
# maybe due to syntax errors or incorrect file names.

$COMMAND --version > out

# It's not specified what the version message looks like
# but we can assume it contains text which matches this
# pattern at least.
assert grep -E '[0-9]\.[0-9]' out

end_of_test
