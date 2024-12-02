#!/bin/bash
source "$PROJECT_ROOT/cltest/_common.sh"

# Test missing argument handling
if $COMMAND 2>/dev/null; then
    exit 1
fi
