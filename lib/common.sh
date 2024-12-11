set -euo pipefail
trap 'echo "$0": non-zero exit value "$?" at lineno ${LINENO} running "${BASH_COMMAND}"' ERR

# todo: change from this being sourced, where it has to be found, to it being
# like `eval $(dv-script-intro)` where it (dv-script-intro) is just found on
# the path like other commands.

cmd=$(basename $0)
# DV_COMMAND is the outer-most command, which is good to log, unless
# something inside overrides it. Generally we'd like dv-prompt-* commands
# to be listed here, since this is used in git log.
#
# So just 'export DV_COMMAND=foo' in a script if you want to manually
# set this.
: "${DV_COMMAND:=$cmd}"
export DV_COMMAND

commit_message_file=_from_developer/commit_message

# ANSI color codes - updated for better visibility on dark backgrounds
RED='\033[1;101m'
MEDRED='\033[0;31m'
GREEN='\033[1;92m'   
YELLOW='\033[1;93m'  
BLUE='\033[1;96m'     # really cyan
GRAY='\033[90m'       
NC='\033[0m'          # No Color

status_file="${DV_STATUS_FILE:-}"
write () {
    if [ -n "${DV_LOGFILE:-}" ]; then
        mkdir -p "$(dirname "$DV_LOGFILE")"
        echo "$(date -u -Ins)" "$@" >> "$DV_LOGFILE"
    fi
    if [[ -n "$status_file" && -f "$status_file" ]]; then
        edits=$(git log --oneline | wc -l)
        # would be nice to have a USD LLM charge total to include
        echo "@$edits" "$@" '--' "$PWD" > "$status_file"
    fi
}

log_error() {
    write "$cmd" ERROR "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${RED}$*${NC}" >&2
}

log_warning() {
    write "$cmd" WARNING "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${YELLOW}$*${NC}" >&2
}

log_warn() {
    log_warning "$@"
}

log_info() {
    write "$cmd" INFO "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${BLUE}$*${NC}" >&2
}

log_success() {
    write "$cmd" SUCCESS "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${GREEN}$*${NC}" >&2
}

log_debug() {
    # default on/off ???
    write "$cmd" DEBUG "$@"
    test -n "${DV_SILENT:-}" && return
    echo -e "${GRAY}[DEBUG] $*${NC}" >&2
}

# Legacy functions with deprecation warnings
error() {
    log_warning "The 'error' function is deprecated. Please use 'log_error' instead."
    log_error "$@"
}

warning() {
    log_warning "The 'warning' function is deprecated. Please use 'log_warning' instead."
    log_warning "$@"
}

info() {
    log_warning "The 'info' function is deprecated. Please use 'log_info' instead."
    log_info "$@"
}

success() {
    log_warning "The 'success' function is deprecated. Please use 'log_success' instead."
    log_success "$@"
}

mkdir_for_files() {
    for file in "$@"; do
        dir="$(dirname "$file")"
        mkdir -p "$dir"
    done
}

sanitize_id() {
    echo "$1" | sed -e 's/[^[:alnum:]_-]/_/g' -e 's/^[^[:alpha:-]]/_%&/'
}

# created by https://claude.ai/chat/73cacb61-8443-4f63-b293-67e85ce028ef
# consider asking it to add arrays, even associated arrays, as directories.
#
# warning - cannot return through sub-shells with parens
read_named_returns() {
    local vars=()
    local file_names=()
    local cmd=""
    local parsing_vars=true
    function log_debug() {
        :
    }
    
    # Parse arguments into vars and cmd
    for arg in "$@"; do
        if [ "$arg" = "--" ]; then
            parsing_vars=false
            continue
        fi
        
        if $parsing_vars; then
            # Split on : if present
            if [[ "$arg" == *:* ]]; then
                local file_name="${arg%%:*}"
                local var_name="${arg#*:}"
                log_debug "Parsed compound name - file: $file_name, var: $var_name"
                vars+=("$var_name")
                file_names+=("$file_name")
            else
                log_debug "Using same name for file and var: $arg"
                vars+=("$arg")
                file_names+=("$arg")
            fi
        else
            cmd="${cmd:+$cmd }$arg"
        fi
    done
    
    # Validate input
    if [ ${#vars[@]} -eq 0 ] || [ -z "$cmd" ]; then
        echo "Usage: read_named_returns var1 [var2 ...] -- command [args ...]" >&2
        return 1
    fi
    
    # Create temporary directory
    local tmp_dir
    tmp_dir=$(mktemp -d)
    if [ ! -d "$tmp_dir" ]; then
        echo "Failed to create temporary directory" >&2
        return 1
    fi
    log_debug "Created temporary directory: $tmp_dir"
    
    # Export directory for child process, in a way that's safe for recursion
    local save_nrd_value="${NAMED_RETURNS_DIR:-}"
    export NAMED_RETURNS_DIR="$tmp_dir"
    
    # Execute the command
    log_debug "Executing command: $cmd"
    eval "$cmd"
    local cmd_status=$?
    log_debug "Command completed with status: $cmd_status"
    
    # Read variables
    local i
    for i in "${!vars[@]}"; do
        local var="${vars[$i]}"
        local file_name="${file_names[$i]}"
        local file="$tmp_dir/$file_name"
        log_debug "Processing return value - file: $file_name, var: $var"
        if [ -f "$file" ]; then
            log_debug "Reading value from $file into $var"
            # printf -v "$var" $(cat "$file")
            # Use eval to set the variable in caller's scope
            eval "$var"'=$(cat "$file")'
            # echo eval "$var"'=$(cat "$file")'
            #s='echo value is "$'$var'"'
            #eval $s
        else
            log_debug "File $file not found, clearing $var"
            # Clear the variable if file doesn't exist
            eval "$var="
        fi
    done

    # Clean up
    NAMED_RETURNS_DIR="$save_nrd_value"
    log_debug "Removing temporary directory: $tmp_dir"
    rm -rf "$tmp_dir"
    
    return $cmd_status
}

write_named_returns() {
    # Check if NAMED_RETURNS_DIR is set
    if [ -z "${NAMED_RETURNS_DIR:-}" ]; then
        log_debug "NAMED_RETURNS_DIR not set, skipping write_named_returns"
        return 0
    fi

    function log_debug() {
        :
    }
    
    log_debug "Writing named returns to directory: $NAMED_RETURNS_DIR"
    
    local arg
    for arg in "$@"; do
        # Split on : if present
        local file_name var_name
        if [[ "$arg" == *:* ]]; then
            file_name="${arg%%:*}"
            var_name="${arg#*:}"
            log_debug "Parsed compound name - file: $file_name, var: $var_name"
        else
            file_name="$arg"
            var_name="$arg"
            log_debug "Using same name for file and var: $arg"
        fi
        
        # Get the value of the variable using indirect reference
        local value="${!var_name:-}"
        
        if [ -n "$value" ]; then
            log_debug "Writing value of $var_name to $NAMED_RETURNS_DIR/$file_name"
            printf "%s" "$value" > "$NAMED_RETURNS_DIR/$file_name"
        else
            log_debug "Variable $var_name is empty or unset, skipping"
        fi
    done
}

using_named_returns() {
    if [ -z "${NAMED_RETURNS_DIR:-}" ]; then
        return 1
    else
        return 0
    fi
}
