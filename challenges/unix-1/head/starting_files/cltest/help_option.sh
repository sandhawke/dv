#!/bin/bash

# Test help options
$COMMAND --help > help.txt

# Should contain usage information
grep -q "Usage:" help.txt || exit 1
grep -q "\-n, \-\-lines" help.txt || exit 1
