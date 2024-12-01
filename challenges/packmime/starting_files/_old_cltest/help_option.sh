#!/bin/bash
output=$($COMMAND --help)
[ $? -eq 0 ] && [[ "$output" == *"Usage"* ]]
