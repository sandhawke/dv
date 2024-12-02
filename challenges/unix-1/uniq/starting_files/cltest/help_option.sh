#!/bin/bash

# Run uniq with help option
$COMMAND --help > "help.txt" 2>&1

# Verify help output contains key options
grep -q -- "-c" "help.txt" &&
grep -q -- "-d" "help.txt" &&
grep -q -- "-u" "help.txt" &&
grep -q -- "-i" "help.txt"
