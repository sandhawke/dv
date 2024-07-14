#!/bin/bash

tests=()
for i in chmod cp dd df du ln ls mkdir mv touch; do
  tests+=("file-$i")
done
for i in cat cut head od sort split tail tr uniq wc; do
  tests+=("text-$i")
done
for i in grep find tar awk gzip; do
  tests+=("hard-$i")
done
for i in ffmpeg busybox bash gcc python; do
  tests+=("extreme-$i")
done

# Function to perform glob matching
match_glob() {
    local pattern=$1
    echo "Using pattern: $pattern"
    local match_found=false
    for str in "${tests[@]}"; do
        if [[ $str == $pattern ]]; then
            echo "Match for '$pattern': $str"
            match_found=true
        fi
    done
    if [ "$match_found" = false ]; then
        echo "No matches found for '$pattern'"
    fi
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <glob_pattern1> [glob_pattern2 ...]"
    echo "       $0 <unix-command1> [unix-command2 ...]"
    echo "Example: $0 'hard-*' ssh"
    echo "Standard test patterns: ${tests[@]}"
    exit 1
fi

# Iterate through all provided patterns
for pattern in "$@"; do
    match_glob "$pattern"
done
