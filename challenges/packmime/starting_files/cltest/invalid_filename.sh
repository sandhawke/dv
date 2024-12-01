#!/bin/bash
source $(dirname $0)/_setup.sh

# Create file with problematic name
touch "file with\"quote.txt"
echo "test" > "file with\"quote.txt"

$COMMAND "file with\"quote.txt" 2> err

# Should skip with warning
assert grep -q "contains invalid characters" err

end_of_test
