#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

file_count=0
for path in *; do
    if [[ -d $path ]]; then
        (cd $path; read_named_returns file_count:new -- ./traverse-fs.sh)
        let file_count=$file_count+$new || true
    fi
    if [[ -f $path ]]; then
        let file_count=$file_count+1 || true
    fi
done
   
write_named_returns file_count
