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

# --- Setups ---

declare -a SETUPS=(
    "curl ipinfo.io | jq"
    "brew install gemini-cli"

)
CMDSE=${SETUPS[1]}

# Setup Commands
s1() {
    echo -e "${CYAN}---START---${NC}"
    echo -e "${BLUE}Executing: $CMDSE ${NC}"
    eval "$CMDSE"
    echo -e "${RED}---END---${NC}"
}

# --- Commands ---

# Execution ZOne
s1
