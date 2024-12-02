#!/bin/bash

# Test error handling for non-existent file
if $COMMAND 644 nonexistent_file 2>/dev/null; then
    exit 1
fi

# Test error handling for invalid mode
if $COMMAND abc regular_file 2>/dev/null; then
    exit 1
fi

exit 0
