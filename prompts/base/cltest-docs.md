## The 'cltest' Framework

Features of cltest:
* Can test any unix software which has a command-line interface
* Language neutral: works with C, Python, Java, Node.JS, etc, via CLI
* Tests are generally easy to read and easy to write
* Simple system, easy to customize
* Tests can be run independently with simple scaffolding, or using dv-cltest command

Tests in cltest are bash scripts. By convention, they have names matching `cltest/*.sh` or, if grouping is useful, `cltest/*/*.sh`.

Each cltest script should:
* assume it's running in a new, empty directory
* assume $TMP is defined as the pathname of another new empty directory
* assume $COMMAND is defined, and use it to run the software being tested
* assume $PROJECT_ROOT is set as the top directory for the project, eg where .gitignore is
* start with these two lines:
```bash
#!/bin/bash
eval $CLTEST_SETUP
```
* use "assert" at least once, providing "true" bash expressions if the test is passing (see examples) 
* end with this line:
```bash
end_of_test
```
* generally look like what a user might type at a command line, except for using $COMMAND instead of the name of the program.
* generally put input and output in files, rather than shell variables
* leave any files in place, for diagnosis, rather than cleaning up


### Examples

Here are some example tests, showing how one could test the behavior of some standard unix commands.

Each one properly assumes COMMAND is set to the proper string to execute the system under test.

#### Testing `date`

```bash
#!/bin/bash
eval $CLTEST_SETUP

$COMMAND -uIseconds > out
sed 's/[0-9]/x/g' < out > masked
assert [ "$(<masked)" = 'xxxx-xx-xx Txx:xx:xx+xx:xx' ]

end_of_test
```

Note how this leaves state in files, so if there were a problem, it would be largely visible from looking at the files, as we want.

#### Testing a C compiler

```bash
#!/bin/bash
eval $CLTEST_SETUP

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

#### Testing `cat` with its `-n` option

Of course this test also uses `cat` to help set up the test. The occurance where it's invoked as $COMMAND is the one doing the actual test.

```bash
#!/bin/bash
eval $CLTEST_SETUP

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

#### Testing `find`

This example uses our write_to_file function which creates directories when necessary, and uses echo internally, so "-e" makes escapes like \n work.

```bash
#!/bin/bash
eval $CLTEST_SETUP
source $(dirname $0)/_setup.sh

write_to_file test/a/b/file "Hello, World!"
write_to_file test/c/d/file "Goodbye, World!"
write_to_file test/e/f/file "Hello, Dolly!"
write_to_file test/g/h/file -e "Hello,\nNewline!"

$COMMAND . -type f -exec grep -q Hello \{\} \; -print | sort > out

cat <<_END > expected
./test/a/b/file
./test/e/f/file
./test/g/h/file
_END

assert diff expected out
end_of_test
```

#### Testing `find` in the current directory

The variable TMP is provided as the pathname of another fresh working directory. This is good for files that might otherwise get in the way of tests.

```bash
#!/bin/bash
eval $CLTEST_SETUP

write_to_file file1.txt 'file1'
write_to_file a/file2.txt 'file2'

# Important to use $TMP here, because otherwise
# the file "out" could be a match, too.
$COMMAND . -type f -print | sort > "$TMP/out"

cat <<_END > "$TMP/expected"
./a/file2.txt
./file1.txt
_END

assert diff "$TMP/expected" "$TMP/out"
end_of_test
```

#### Generic test of the `--version` option

This is a good general test to see if the command can be executed at all. It should usual be included in a test suite.

```bash
#!/bin/bash
eval $CLTEST_SETUP

# If it fails this, the program probably isn't running at all,
# maybe due to syntax errors or incorrect system configuration.

$COMMAND --version > out

# It's not specified what the version message should looks like
# but we can assume it will contain a decimal number.
assert grep -E '[0-9]\.[0-9]' out

end_of_test
```

----