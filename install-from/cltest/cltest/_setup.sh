# Tests in this directory should include this file by starting with
#    #!/bin/bash
#    source $(dirname $0)/_setup.sh

# This means any command with a non-zero exit code will cause
# the script to exit. Probably what we want for tests, but there
# are some situations where this is bad, like shell math which
# evaluates to zero gives a non-zero exit. So use "|| true" after
# commands where you want to ignore the exit code.
set -euo pipefail

if [ -z "${PROJECT_ROOT:-}" -o -z "${COMMAND:-}" ]; then
    echo "cltest files should be run using dv-cltest"
    exit 1
fi

asserts_passed=0
asserts_failed=0

function assert() {
    if "$@"; then
        let asserts_passed=1+$asserts_passed || true
    else
        let asserts_failed=1+$asserts_failed || true
        echo >&2 "assertion failed, cltest '$0', assertion: $(dv-quote-arguments "$@")"
    fi
}

function end_of_test() {
    # leave files around for diagnosis
    exit $asserts_failed
}
