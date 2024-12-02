#!/bin/bash
source $(dirname $0)/_setup.sh

# Create a file with many tokens
yes "testing tokens" | head -n 1000 > large.txt

$COMMAND --max-file-tokens=10 large.txt > out

# Should include truncation notice
assert grep -q 'X-Truncation-Notice.*tokens' out

end_of_test
