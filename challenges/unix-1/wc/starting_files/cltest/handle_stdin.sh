#!/bin/bash
# Test reading from standard input
echo -e "one\ntwo\nthree" | $COMMAND
[ $? -eq 0 ]
