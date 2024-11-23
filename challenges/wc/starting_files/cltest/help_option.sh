#!/bin/bash
# Test --help option
$COMMAND --help 2>&1 | grep -q "Usage"
