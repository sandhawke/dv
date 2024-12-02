#!/bin/bash
# Test --help option displays usage information

$COMMAND --help > help.txt

# Verify help output contains key elements
grep -q "Usage:" help.txt || exit 1
grep -q -- "-a, --append" help.txt || exit 1
grep -q -- "-i, --ignore-interrupts" help.txt || exit 1
