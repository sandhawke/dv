. $(dirname $0)/_common.sh
set -eu

# run npm test within our .sh test system, so that running all the .sh tests
# will mean running all the tests, including .js ones.
#
# Beware: do not make 'npm test' run the .sh tests! That would cause a loop.

exec npm test
