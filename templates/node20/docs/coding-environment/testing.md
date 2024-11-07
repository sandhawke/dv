# Test Scripts

Our primary software testing system is based on bash scripts. Each feature of the documented software system should be tested by one or more scripts. The scripts go in the ./test directory, named to describe the feature or behavior they are testing, in kebab case, ending with ".sh". Each test script should return exit code 0 if it succeeds and non-zero if it fails. It should send helpful diagnostics to stderr (or stdout if that's easier), especially if it fails.

It may be helpful to use environment variables to turn on additional logging when set to certain values. Developer and tools can set those variables during debugging.

If there is a program specification available, use that as the primary source of what should be tested and how the software should behave. If there is no spec, you may use the software as a guide.

Common features can be put in .test/_common.sh to be sourced by the test scripts. Files starting with "_" will not be run as tests by the test runner. Example inputs and output can be put in subdirectories of ./test.

Have the tests use $PROGRAM as the start of the command line (such as "path/to/bin" or "node path/to/file"). Do not bother to check that $PROGRAM is set or give it a default value.

