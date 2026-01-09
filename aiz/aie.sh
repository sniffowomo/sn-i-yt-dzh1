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

# --- AI Specific Execution Commands ---

# Mods Commands
mf1() (
    declare -a MFC=(
        "mods -f \"Give me a terraform cheatsheet to be used in production \" -t \"Terraform cheatsheet\" >> tf1.md"
    )
    CMDMF=${MFC[0]}
    echo -e "${CYAN}---AI MODULE START---${NC}"
    echo -e "${BLUE}Executing: $CMDMF ${NC}"
    eval "$CMDMF"
    echo -e "${RED}---AI MODULE END---${NC}"
)

# Gemini Cli Commands
gm1() (
    declare -a MFC=(
        "gemini -f \"Write a terraform cheatsheet to be used in production\" >> gm_tf1.md"
    )
    CMDMF=${MFC[0]}
    echo -e "${CYAN}---AI MODULE START---${NC}"
    echo -e "${BLUE}Executing: $CMDMF ${NC}"
    eval "$CMDMF"
    echo -e "${RED}---AI MODULE END---${NC}"
)

# --- Commands ---

# Execution ZOne
# s1
# mf1
gm1
