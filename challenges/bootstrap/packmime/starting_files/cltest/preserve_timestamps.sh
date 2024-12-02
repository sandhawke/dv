#!/bin/bash
source $(dirname $0)/_setup.sh

echo "test" > input.txt
touch -t 202401010000 input.txt

$COMMAND --preserve input.txt > out

assert grep -q 'Content-Modified: 2024-01-01T00:00:00' out

end_of_test
