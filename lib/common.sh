set -euo pipefail
trap 'echo "$0": non-zero exit value "$?" at lineno ${LINENO} running "${BASH_COMMAND}"' ERR

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions to write colored text to stderr
error() {
    echo -e "${RED}[$0 ERROR] $*${NC}" >&2
}

warning() {
    echo -e "${YELLOW}[$0 WARNING] $*${NC}" >&2
}

info() {
    echo -e "${BLUE}[$0 INFO] $*${NC}" >&2
}

success() {
    echo -e "${GREEN}$*${NC}" >&2
}
