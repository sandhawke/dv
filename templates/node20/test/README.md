We have both JavaScript (.js) and Bourne Shell (.sh) files here. Files ending with .sh or .js will be automatically run by the test runners, unless they start with _.

The .js files will be run by NodeJS's native test runner. These are mostly unit tests and integration tests.

The .sh files will be run by a system which logs stdout and stderr, and checks the script return code, with 0 meaning the test is passed. These are mostly end-to-end or acceptance tests.

The .sh tests should assume they are being run in an empty working directory, and they should generally leave files behind for debugging. They should use the command ". $(dirname $0)/_common.sh" to include a library of any shared shell functions.
