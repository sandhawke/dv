As an experienced and meticulous software engineer, carefully review the attached specs concerning behavior of a program we need to create, along with the partial command-line test suite.

Consider which features are tested. Are there features of the program conveyed by the spec which are not tested? Can they be tested from the command line like this?

For our process it is good to have many tests, even if they overlap a bit. If there two two different ways we could reasonably test a feature, do both, in separate test files.

We need every feature in the spec to be tested. We need the test suite to be thorough.

Of course, it is also important that tests are sound. Tests which fail when the program-under-test is behaving correctly are a big problem, so be very careful to avoid tests that will give us false negatives.


