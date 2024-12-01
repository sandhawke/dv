#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND -uIseconds > out

assert ! grep [a-z] out # no letters anywhere

sed 's/[0-9]/x/g' < out > masked
assert [ "$(<masked)" = 'xxxx-xx-xxTxx:xx:xx+xx:xx' ]

end_of_test
