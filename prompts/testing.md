# Test Scripts

We are using a software testing system based on bash scripts. Each feature of the documented software system should be tested by one or more scripts. The scripts go in the ./tests directory, named to describe the feature or behavior they are testing, in kebab case, ending in .sh. The test should return exit code 0 if they succeed, non-zero otherwise. They should print helpful diagnostics to stdout or stderr, especially when they fail.

Common features should be put in tests/_common.sh which should be sourced by all tests. Files starting with _ will not be run as tests by the test runner. Example inputs and output can be put in subdirectories of ./tests

Have the tests use $PROGRAM as the executable being tested. Have _common.sh set it to a reasonable value if the variable does not already have a value.

If there are elements of the documentation you do not understand, please add or revise a docs/issues.md file which enumerates items that should be clarified for you to write complete and accurate tests.

If all the tests appear accurate and all features are tested, just say "Done."
