#!/bin/bash
# Test invalid option handling
$COMMAND -z "$PROJECT_ROOT/cltest/_test_input.txt" 2>&1 | grep -q "invalid option"
[ $? -eq 1 ]
