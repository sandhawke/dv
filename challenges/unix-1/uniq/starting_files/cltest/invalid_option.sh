#!/bin/bash

# Run uniq with invalid option
$COMMAND --invalid-option > "output.txt" 2> "error.txt" && exit 1

# Verify error message exists
[ -s "error.txt" ]
