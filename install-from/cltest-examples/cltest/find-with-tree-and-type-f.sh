#!/bin/bash
source $(dirname $0)/_setup.sh

mkdir -p dir1/{subdir1,subdir2}/{sub-subdir1,sub-subdir2}
touch dir1/file1.txt dir1/subdir1/file2.txt dir1/subdir2/file3.txt

# avoid race condition where it shows up during run
touch out 

$COMMAND . -type f | sort > out

cat <<_END > expected
./dir1/file1.txt
./dir1/subdir1/file2.txt
./dir1/subdir2/sub-subdir2/file3.txt
./out
_END

assert diff expected out
end_of_test
