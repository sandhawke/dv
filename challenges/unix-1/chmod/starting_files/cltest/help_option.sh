#!/bin/bash

# Test help option
$COMMAND --help | grep -q "Usage:"
