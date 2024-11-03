# Test Scripts

We are using a software testing system based on bash scripts. Each feature of the documented software system should be tested by one or more scripts. The scripts go in the ./test directory, named to describe the feature or behavior they are testing, in kebab case, ending in .sh. Each test script should return exit code 0 if they succeed, non-zero if they fail. They should print helpful diagnostics to stderr, especially when they fail.

If there is a program specification available, use that as the primary source of what should be tested and how the software should behave. If there is no spec, you may use the software as a guide.

Common features can be put in .test/_common.sh to be sourced by the test scripts. Files starting with "_" will not be run as tests by the test runner. Example inputs and output can be put in subdirectories of ./test.

Have the tests use $PROGRAM as the executable being tested. Assume it will be set such that it can be used as argv[0].

If there are elements of the documentation you do not understand, please add or revise a docs/issues.md file which enumerates items that should be clarified for you to write complete and accurate tests.

If all the tests appear accurate and all features are tested, update or create a file "./test/_ready_for_testing".

