#!/bin/bash
source $(dirname $0)/_setup.sh

write_to_file file1.txt 'file1'
write_to_file a/file2.txt 'file2'

# Important to use $TMP here, because otherwise
# the file "out" could be matched, too.
$COMMAND . -type f -print | sort > "$TMP/out"

cat <<_END > "$TMP/expected"
./a/file2.txt
./file1.txt
_END

assert diff "$TMP/expected" "$TMP/out"
end_of_test
