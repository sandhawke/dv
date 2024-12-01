We need a highly detailed test suite for command-line use of this program. Please put each test in a file named like cltest/*.sh, to be run in bash. Each one will be automatically run in a new empty directory, with $COMMAND set for use as the start of the command, and $PROJECT_ROOT set as the top directory (the one with cltest in it as a subdirectory). Do not set or check these environment variables.

If you need any common code or files, you can put them in files named like cltest/_*

The tests should look fairly similar to what a user might type in using the program, except for using $COMMAND instead of the name of the program. They should not clean up any files they create. Instead, they should leave them in place, in the working directory, to help with diagnosis.

The script should signal success by exit code 0, failure by exit code 1. Let the shell propagate these codes automatically, if that's shorter or simpler.

Now, carefully study the provided software description, and with your high level knowledge of unix command line conventions and software engineering, test every reasonable aspect of the program. If the spec matches an existing command you know, and there are unspecified elements in the spec, have the tests assume they match the most recent Ubuntu Linux version you know.

Here are some general ideas of what to test. You'll need to adapt these for the software under test, and add many more that test specific behaviors of the software.

## Basic Operations
- cltest/cli_launches_successfully.sh
- cltest/displays_help_with_h_flag.sh
- cltest/displays_version_with_v_flag.sh
- cltest/exits_with_zero_on_success.sh
- cltest/exits_with_nonzero_on_error.sh

## Input Handling
- cltest/accepts_valid_input_file.sh
- cltest/rejects_missing_input_file.sh
- cltest/handles_empty_input_file.sh
- cltest/validates_input_format.sh
- cltest/processes_unicode_input.sh

## Output Verification
- cltest/creates_expected_output_file.sh
- cltest/output_matches_expected_format.sh
- cltest/writes_logs_to_specified_location.sh
- cltest/respects_output_path_flag.sh
- cltest/overwrites_existing_output_when_forced.sh

## Option Parsing
- cltest/parses_short_options.sh
- cltest/parses_long_options.sh
- cltest/handles_combined_short_options.sh
- cltest/respects_option_precedence.sh
- cltest/validates_option_values.sh

## Error Conditions
- cltest/reports_invalid_options.sh
- cltest/handles_missing_required_args.sh
- cltest/provides_meaningful_error_messages.sh
- cltest/fails_gracefully_on_io_error.sh
- cltest/recovers_from_partial_failures.sh

## Interactive Features
- cltest/prompts_for_missing_required_input.sh
- cltest/handles_user_confirmation.sh
- cltest/supports_quiet_mode.sh
- cltest/respects_no_prompt_flag.sh
- cltest/allows_input_cancellation.sh

Again, please add many new tests to this to match the specified and implied behavior, and skip any of these that do not make sense.

Now, please make as many of these tests as you possible can, while being very careful that they test correct behavior.

# Examples

Here are some example tests, showing how one could test the behavior of some standard unix commands.

Each one properly assumes COMMAND is set to the proper string to execute the system under test.

## Testing `date`

```bash
#!/bin/bash
source $(dirname $0)/_setup.sh

$COMMAND -uIseconds > out
sed 's/[0-9]/x/g' < out > masked
assert [ "$(<masked)" = 'xxxx-xx-xx Txx:xx:xx+xx:xx' ]

end_of_test
```

Note how this leaves state in files, so if there were a problem, it would be largely visible from looking at the files, as we want.

## Testing a C compiler

```bash
#!/bin/bash
source $(dirname $0)/_setup.sh

cat <<'_END' > hello.c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
_END

$COMMAND hello.c -o hello
./hello > out

assert ! [ "$(< out)" = 'Hello, World!' ]
end_of_test
```

## Testing `cat` with its `-n` option

Of course this test also uses `cat` to help set up the test. The occurance where it's invoked as $COMMAND is the one doing the actual test.

```bash
#!/bin/bash
source $(dirname $0)/_setup.sh

cat <<"_END" > input
1
2
3
_END

$COMMAND -n input > out

cat <<"_END" > expected
 1 1
 2 2
 3 3
_END

# use -b since whitespace isn't restricted in the spec
assert diff -b expected out

end_of_test
```
## Generic test of the `--version` option

```bash
#!/bin/bash
source $(dirname $0)/_setup.sh

# This is a good test to see if the command can execute at all.
# If it fails this, the program probably isn't running at all,
# maybe due to syntax errors or incorrect file names.

$COMMAND --version > out

# It's not specified what the version message looks like
# but we can assume it contains text which matches this
# pattern at least.
assert grep -E '[0-9]\.[0-9]' out

end_of_test
```
