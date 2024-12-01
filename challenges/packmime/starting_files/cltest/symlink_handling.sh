#!/bin/bash
source $(dirname $0)/_setup.sh

echo "target content" > target.txt
ln -s target.txt link.txt

# Test follow mode
$COMMAND --symlink-action=follow link.txt > out.follow
assert grep -q 'target content' out.follow

# Test describe mode
$COMMAND --symlink-action=describe link.txt > out.describe
assert grep -q 'symbolic link to' out.describe

# Test skip mode
$COMMAND --symlink-action=skip link.txt > out.skip
assert [ $(wc -l < out.skip) -eq 3 ]  # Just headers and boundary

end_of_test
