set -euo pipefail
trap 'echo "$0": non-zero exit value "$?" at lineno ${LINENO} running "${BASH_COMMAND}"' ERR

cmd=$(basename $0)
# DV_COMMAND is the outer-most command, which is good to log, unless
# something inside overrides it. Generally we'd like dv-prompt-* commands
# to be listed here, since this is used in git log.
: "${DV_COMMAND:=$cmd}"

if [ -z "$PROJECT_DIR" ]; then
    if ! PROJECT_DIR=$(git rev-parse --show-toplevel); then
        if [ -d .dv ]; then
    fi
        
export 

# ANSI color codes - updated for better visibility on dark backgrounds
RED='\033[1;101m'      # Bright Red
GREEN='\033[1;92m'    # Bright Green
YELLOW='\033[1;93m'   # Bright Yellow
BLUE='\033[1;96m'     # Bright CYAN
NC='\033[0m'          # No Color

# New logging functions
log_error() {
    echo -e "${RED}[$cmd ERROR] $*${NC}" >&2
}

log_warning() {
    echo -e "${YELLOW}[$cmd WARNING] $*${NC}" >&2
}

log_info() {
    echo -e "${BLUE}[$cmd INFO] $*${NC}" >&2
}

log_success() {
    echo -e "${GREEN}$*${NC}" >&2
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
