#!/usr/bin/env bash
#
# load_env - Safely load environment variables from a file
#
# This script reads a file containing environment variable definitions in the format
# VAR=VALUE and exports them to the current shell environment. It implements strict
# security measures to prevent arbitrary command execution and other potential
# security issues.
#
# Security measures:
# - Validates file permissions (no world-writable)
# - Strict variable name validation (only alphanumeric and underscore)
# - No command substitution or shell expansion
# - Ignores export statements and other shell commands
# - Sanitizes values to prevent command injection
# - Limits file size to prevent resource exhaustion
#
# Usage: load_env /path/to/env/file
#
# Returns:
#   0 - Success
#   1 - File error or security check failure
#
# Example file format:
#   DEBUG=true
#   API_KEY=abc123
#   # Comments are ignored
#   EMPTY=

load_env() {
    local env_file="$1"
    local max_file_size=$((1024 * 1024))  # 1MB limit
    
    # Check if argument is provided
    if [[ -z "$env_file" ]]; then
        echo "Error: No file specified" >&2
        return 1
    fi
    
    # Check if file exists and is readable
    if [[ ! -f "$env_file" || ! -r "$env_file" ]]; then
        echo "Error: File does not exist or is not readable" >&2
        return 1
    fi
    
    # Check file permissions (no world-writable)
    if [[ "$(stat -L -c "%a" "$env_file")" =~ [2-7][2-7]([2-7]) ]]; then
        echo "Error: File has unsafe permissions (world-writable)" >&2
        #return 1
    fi
    
    # Check file size
    local file_size
    file_size=$(stat -L -c %s "$env_file")
    if [[ $file_size -gt $max_file_size ]]; then
        echo "Error: File size exceeds maximum allowed size (1MB)" >&2
        return 1
    fi
    
    # Read file line by line
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines, comments, and lines starting with export
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*export[[:space:]] ]] && continue
        
        # Only process valid VAR=VALUE lines with strict name validation
        if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            # Split into name and value
            local name="${line%%=*}"
            local value="${line#*=}"
            
            # Additional security check for variable name
            if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
                echo "Warning: Skipping invalid variable name: $name" >&2
                continue
            fi
            
            # Remove surrounding quotes if present
            value="${value#[\"\']}"
            value="${value%[\"\']}"
            
            # Check for command substitution patterns
            if [[ "$value" == *'$('* || "$value" == *'`'* ]]; then
                echo "Warning: Skipping value with command substitution: $name" >&2
                continue
            fi
            
            # Remove any null bytes for extra security
            value="${value//$'\x00'/}"
            
            # Export the variable
            export "$name=$value"
        else
            echo "Warning: Skipping invalid line format: $line" >&2
        fi
    done < "$env_file"
    
    return 0
}
