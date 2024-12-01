#!/bin/bash
source $(dirname $0)/_setup.sh

# Create a file larger than 10 bytes
echo "this is more than ten bytes of text" > large.txt

$COMMAND --max-file-bytes=10 large.txt > out

# Should include truncation notice
assert grep -q 'X-Truncation-Notice' out

end_of_test
