#!/bin/bash
# Test handling of invalid command line options

# Invalid option should produce error and exit with non-zero status
if $COMMAND --invalid-option 2>/dev/null; then
    echo "Expected failure with invalid option"
    exit 1
fi
