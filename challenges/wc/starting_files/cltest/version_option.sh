#!/bin/bash
# Test --version option
$COMMAND --version 2>&1 | grep -q -E "^wc \([^)]+\) [0-9]"
