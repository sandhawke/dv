#!/bin/bash

# Test invalid option
$COMMAND . -invalid 2> error.txt
[ $? -ne 0 ]

# Test non-existent path
$COMMAND ./nonexistent 2> error2.txt
[ $? -ne 0 ]

# Test invalid expression
$COMMAND . -type 2> error3.txt
[ $? -ne 0 ]
