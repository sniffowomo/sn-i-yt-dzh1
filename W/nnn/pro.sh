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
    "docker volume create n8n_data"
    "docker run -it --rm
    --name n8n
    -p 5678:5678
    -e GENERIC_TIMEZONE=\"GB\"
    -e TZ=\"GB\"
    -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
    -e N8N_RUNNERS_ENABLED=true
    -v n8n_data:/home/node/.n8n
    docker.n8n.io/n8nio/n8n"

)

# Setup Commands
s1() {
    echo -e "${CYAN}---START---${NC}"
    echo -e "${BLUE}Executing: ${SETUPS[0]} ${NC}"
    eval "${SETUPS[0]}"
    echo -e "${BLUE}Executing: ${SETUPS[1]} ${NC}"
    eval "${SETUPS[1]}"
    echo -e "${RED}---END---${NC}"
}

# --- Commands ---

# Execution ZOne
s1
