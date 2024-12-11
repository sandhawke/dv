#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

read_named_returns depth max_entries count paths -- ./traverse-fs.sh

log_info "depth=$depth"
log_info "max_entries=$max_entries"
log_info "max_entries_at=$max_entries_at"
log_info "count=$count"
log_info "paths=$paths"
