#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

# Initialize variables
max_branch=0
current_branch=0
max_depth=1
i=1  # Start at 1 to skip script name

while [ $i -le $# ]; do
    arg="${!i}"
    
    if [ "$arg" = "(" ]; then
        current_branch=$((current_branch + 1))
        if [ $current_branch -gt $max_branch ]; then
            max_branch=$current_branch
        fi
        
        # Collect subtree arguments
        subtree=()
        paren_count=1
        i=$((i + 1))
        
        while [ $i -le $# ] && [ $paren_count -gt 0 ]; do
            arg="${!i}"
            if [ "$arg" = "(" ]; then
                paren_count=$((paren_count + 1))
            elif [ "$arg" = ")" ]; then
                paren_count=$((paren_count - 1))
            fi
            
            if [ $paren_count -gt 0 ]; then
                subtree+=("$arg")
            fi
            i=$((i + 1))
        done
        
        # Process subtree recursively
        if read_named_returns depth:sub_depth branch:sub_branch -- "$0" "${subtree[@]}"; then
            sub_depth=$((sub_depth + 1))
            if [[ $sub_depth -gt $max_depth ]]; then
                max_depth=$sub_depth
            fi
            if [[ $sub_branch -gt $max_branch ]]; then
                max_branch=$sub_branch
            fi
        fi
        
        current_branch=$((current_branch - 1))
    else
        i=$((i + 1))
    fi
done

if using_named_returns; then
    write_named_returns depth:max_depth branch:max_branch
else
    echo "Depth: $max_depth"
    echo "Max Branch Factor: $max_branch"
fi
