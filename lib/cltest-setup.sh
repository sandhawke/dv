# This code is sourced or textually prepended to every cltest script
# before it is run.  It also has end_of_test appended.


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

# Program-specific functions should go in _helpers.sh not _setup.sh
helpers="$(dirname "$0")/_helpers.sh"
if [[ -f $helpers ]]; then
  source "$helpers"
fi

asserts_passed=0
asserts_failed=0

function assert() {
    caller_info=($(caller 0))
    local offset=4 # sorry, this has to match the number of lines prefixed to the file in dv_cltest write_test()
    let line="${caller_info[0]} - $offset"
    loc="line $line in $DV_CLTEST_FILENAME"
    if "$@"; then
        let asserts_passed=1+$asserts_passed || true
        echo >&2 "assertion PASSED, assertion: $(dv-quote-arguments "$@") called from $loc"
    else
        let asserts_failed=1+$asserts_failed || true
        echo >&2 "assertion failed, assertion: $(dv-quote-arguments "$@") called from $loc"
    fi
}

function end_of_test() {
    echo 'end_of_test reached - test ran to completion' > "$TMP/end_of_test"
    # leave files around for diagnosis
    if [[ $asserts_passed = 0 && $asserts_failes = 0 ]]; then
        echo >&2 "no assertions were run in this test - that's a fail"
        exit 1
    fi
    exit $asserts_failed
}
