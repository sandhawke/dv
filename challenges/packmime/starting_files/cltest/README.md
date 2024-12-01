# cltest Command Line Testing System

Files in this directory are used by the cltest test runner as part of automated code testing. The test results will be made available to users and other systems in cltest-results.

The tests should look fairly similar to what a user might type when using the program at a command line, except we use $COMMAND instead of the name of the program, so tests can be run on software that is not yet installed. It will be set by test running system, usually using .env.

Tests should not clean up any files they create. Instead, they should leave them in place, in the working directory, to help with diagnosis. Each test will be run in a new empty directory. Tests should use $COMMAND as is, without modifying or checking it.

The environment variable PROJECT_ROOT will contain the pathname of the directory where general project files are, such as README.md, LICENSE, .gitignore. Other files and directories here will depend on the language and system. Files in this directory tree should not be modified. Tests might use this variable like `cp -a "$PROJECT_ROOT/cltest/sample-file-1" .` to copy a sample file to the working directory of the running test.

The script should signal success by exit code 0, failure by an non-zero exit code. Let the shell propagate these codes automatically, if that's shorter or simpler.

We have _setup.sh which defines shell functions `assert` and `end_of_test`, making tests somewhat easier to read and write. The end_of_test function exits with an exit code based on whether any `assert` expressions were false.
