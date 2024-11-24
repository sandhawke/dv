#!/bin/bash

# Shared functions used across dv-version-create scripts

# Diagnostic output function
log() {
    if [ "$QUIET" = false ]; then
        # Use gray color (8-bit color code 240)
        echo -e "\033[38;5;240mdv-version-create: $*\033[0m" >&2
    fi
}

# Function to find highest sequential number in a directory
## DEPRECATED - use new_name
find_highest_seq() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo "0"
        return
    fi
    local highest
    highest=$(ls -1 "$dir" | grep -E '^[0-9]+$' | sort -n | tail -n 1)
    if [ -z "$highest" ]; then
        echo "0"
    else
        echo "$highest"
    fi
}

# Function to update the 'latest' symlink
update_latest_symlink() {
    local new_version="$1"
    local latest_link=".dv/versions/latest"

    # Remove existing symlink if it exists
    if [ -L "$latest_link" ]; then
        log "Removing existing 'latest' symlink"
        rm "$latest_link"
    elif [ -e "$latest_link" ]; then
        # If it exists but isn't a symlink, that's an error
        echo "Error: $latest_link exists but is not a symlink" >&2
        exit 1
    fi

    log "Creating new 'latest' symlink to $new_version"
    ln -s "$new_version" "$latest_link"
}

# Function to enter interactive shell
enter_shell() {
    local version_dir="$1"
    local exec_cmd="$2"
    log "Entering interactive shell in $version_dir"
    log "Exit the shell to complete version creation"
    cd "$version_dir"
    eval "$exec_cmd"
    log "Shell exited"
}
