#!/bin/bash
source $(dirname $0)/_setup.sh

write_to_file test/a/b/file "Hello, World!"
write_to_file test/c/d/file "Goodbye, World!"
write_to_file test/e/f/file "Hello, Dolly!"
write_to_file test/g/h/file -e "Hello,\nNewline!"

$COMMAND . -type f -exec grep -q Hello \{\} \; -print | sort > out

cat <<_END > expected
./test/a/b/file
./test/e/f/file
./test/g/h/file
_END

assert diff expected out
end_of_test
