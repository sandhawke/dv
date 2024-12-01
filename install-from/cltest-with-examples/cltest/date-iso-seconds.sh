#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND -uIseconds > out
sed 's/[0-9]/x/g' < out > masked
assert [ "$(<masked)" = 'xxxx-xx-xx Txx:xx:xx+xx:xx' ]

end_of_test
