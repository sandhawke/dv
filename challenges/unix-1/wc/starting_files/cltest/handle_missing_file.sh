#!/bin/bash
# Test handling of non-existent file
$COMMAND nonexistent.txt 2>/dev/null
[ $? -eq 1 ]
