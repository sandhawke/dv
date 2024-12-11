#!/bin/bash
source $(dv-path lib/common.sh) # -*-mode: sh-mode -*-

# Node creation helper
create_node() {
    local value=$1
    local left=${2:-}  # Directory name of left subtree
    local right=${3:-} # Directory name of right subtree
    
    local dir=$(mktemp -d)
    echo "$value" > "$dir/value"
    [[ -n "$left" ]] && echo "$left" > "$dir/left"
    [[ -n "$right" ]] && echo "$right" > "$dir/right"
    echo "$dir"
}

# Find min and max values in tree
find_minmax() {
    local node_dir=$1
    
    # Base case - empty tree
    if [[ -z "$node_dir" ]]; then
        write_named_returns min max
        return
    fi
    
    local value=$(<"$node_dir/value")
    local min=$value
    local max=$value
    
    # Process left subtree if it exists
    if [[ -f "$node_dir/left" ]]; then
        local left_dir=$(<"$node_dir/left")
        local left_min left_max
        read_named_returns left_min left_max -- find_minmax "$left_dir"
        [[ -n "$left_min" ]] && min=$(( left_min < min ? left_min : min ))
        [[ -n "$left_max" ]] && max=$(( left_max > max ? left_max : max ))
    fi
    
    # Process right subtree if it exists
    if [[ -f "$node_dir/right" ]]; then
        local right_dir=$(<"$node_dir/right")
        local right_min right_max
        read_named_returns right_min right_max -- find_minmax "$right_dir"
        [[ -n "$right_min" ]] && min=$(( right_min < min ? right_min : min ))
        [[ -n "$right_max" ]] && max=$(( right_max > max ? right_max : max ))
    fi
    
    write_named_returns min max
}

# Demo usage
demo() {
    # Create a tree:
    #       5
    #      / \
    #     3   8
    #    /   / \
    #   1   6   9
    
    local leaf1=$(create_node 1)
    local leaf6=$(create_node 6)
    local leaf9=$(create_node 9)
    local node3=$(create_node 3 "$leaf1")
    local node8=$(create_node 8 "$leaf6" "$leaf9")
    local root=$(create_node 5 "$node3" "$node8")
    
    local tree_min tree_max
    read_named_returns tree_min tree_max -- find_minmax "$root"
    echo "Tree minimum: $tree_min"
    echo "Tree maximum: $tree_max"
    
    # Cleanup
    rm -rf "$leaf1" "$leaf6" "$leaf9" "$node3" "$node8" "$root"
}

# Run the demo
demo
