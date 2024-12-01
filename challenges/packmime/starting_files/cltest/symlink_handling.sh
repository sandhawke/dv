#!/bin/bash
source $(dirname $0)/_setup.sh

echo "target content" > target.txt
ln -s target.txt link.txt

# Test follow mode
$COMMAND --symlink-action=follow link.txt > out.follow
assert grep -q 'Content-Disposition: attachment; filename="link.txt"' out.follow
assert grep -q 'target content' out.follow

# Test describe mode
$COMMAND --symlink-action=describe link.txt > out.describe
assert grep -q 'Content-Disposition: form-data; name="symbolic-link"' out.describe
assert grep -q 'link.txt.*symbolic link to.*target.txt' out.describe

# Test skip mode
$COMMAND --symlink-action=skip link.txt > out.skip
assert [ $(grep -c 'Content-Disposition' out.skip) -eq 0 ]

end_of_test
