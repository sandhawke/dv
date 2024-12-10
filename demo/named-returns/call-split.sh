#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

read_named_returns dir base -- ./split.sh /foo/bar/baz.xyz

log_info "dir=$dir base=$base"

read_named_returns dir:dir2 base:base2 -- ./split.sh /foo/bar/baz.xyz .xyz

log_info "dir2=$dir2 base2=$base2"
