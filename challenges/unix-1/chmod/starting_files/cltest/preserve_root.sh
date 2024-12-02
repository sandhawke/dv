#!/bin/bash

# Test --preserve-root behavior
if $COMMAND --preserve-root -R 777 / 2>/dev/null; then
    exit 1
fi

exit 0
