#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

dir=$(dirname "$1")
base=$(basename "$1" "${2:-}")

write_named_returns dir base
