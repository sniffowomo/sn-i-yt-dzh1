#!/usr/bin/env bash
# General stuff setip

# Error handling
set -euo pipefail

# Colors
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BLUE=$'\e[34m'
PURPLE=$'\e[35m'
CYAN=$'\e[36m'
WHITE=$'\e[37m'
NC=$'\e[0m' # No Color

# Actual Commands section

# Array definition

declare -a CMDS=(
    "curl ipinfo.io | jq"
    "go install github.com/charmbracelet/mods@latest" # Mods
    go install github.com/karol-broda/snitch@latest   # Snitch - Netstat

)
CMDSE=${CMDS[1]}

m1() {
    echo -e "${CYAN}---START---${NC}"
    echo -e "${BLUE}Executing: $CMDSE ${NC}"
    eval "$CMDSE"
    echo -e "${RED}---END---${NC}"
}

# Execution ZOne
m1
