#!/bin/bash
source $(dirname $0)/_setup.sh

# Create multiple small files
for i in {1..5}; do
    echo "file$i" > "file$i.txt"
done

# Set tiny context to force multiple overflow files
$COMMAND --context=2 file*.txt

# Check multiple overflow files created
assert [ $(ls packmime-overflow.*.*.mime 2>/dev/null | wc -l) -gt 1 ]

end_of_test
