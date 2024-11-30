#!/bin/bash
$COMMAND nonexistent.txt
[ $? -ne 0 ]
