We have both JavaScript (.js) and Bourne Shell (.sh) files here. Files ending with .sh or .js will be automatically run by the test runners, unless they start with _.

The .js files will be run by NodeJS's native test runner. These are mostly unit tests and integration tests. If these tests create any files or directories, they must do it under $TEST_DIR (available as an environment variable).

The .sh files will be run by a system which logs stdout and stderr, and checks the script return code, with 0 meaning the test is passed. These are mostly end-to-end or acceptance tests. These tests will be run with the current-working-directory being a new empty working directory ($TEST_DIR). It is good to leave files behind for debugging. To access the project directory, use $PROJECT_ROOT.  For example, a test script might run $PROJECT_ROOT/src/cli.js as the command.

The .sh tests should use the command ". $(dirname $0)/_common.sh" to include a library of any shared shell functions.
