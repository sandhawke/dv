# Load shared functions, if any, from _common.sh 
. $(dirname $0)/_common.sh
set -eu

# Example acceptance test, in this case assuming we're implementing the
# "date" unix command. Real test files should be named after feature or
# approach being used in that test.

# Just use the files called stdout and stderr. Script will be run in a
# fresh directory, and this helps when we're debugging and looking at
# the files left behind. By keeping state in files, we don't need to
# output any details. Whoever is doing the debugging can see what's
# left in the files.
date > stdout 2> stderr

sed 's/[0-9]/X/g' < stdout > stdout-masked

if ! grep -q '^[A-Za-z]* [A-Za-z]* [X ]X XX:XX:XX [A-Z]* [A-Z]* XXXX$' < stdout-masked; then
    echo "ERROR: Date output format does not match expected pattern"
    exit 1
fi

# Test 2: Check if stderr is empty
if [ -s stderr ]; then
    echo "ERROR: Expected empty stderr"
    exit 1
fi
