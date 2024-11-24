#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test invalid option handling
if $COMMAND --invalid-option 2>/dev/null; then
    exit 1
fi
