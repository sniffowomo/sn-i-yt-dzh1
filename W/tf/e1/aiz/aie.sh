#!/usr/bin/env bash
# AI tools execution

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

# Note claude code is bastardfuckerbastard , need telephone for pantysmell

declare -a SETUPS=(
    "curl ipinfo.io | jq"
    "brew install gemini-cli"
    "brew uninstall gemini-cli"
    "brew install --cask claude-code"
    "brew uninstall --cask claude-code"
    "bun install -g @google/gemini-cli@preview"
    "curl -fsSL https://opencode.ai/install | bash" # Install OpenCode

)
CMDSE=${SETUPS[6]}

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
        "mods -f \"Give me concise comparison between Agentic Cli tools - OpenCode, Droids, AMP Cli, Gemini Cli , Claude code, Mods - Focus on high impact differences in pricing and production usage , and find out which agentic platform I can use today for work with my clients \" -t \"Terraform cheatsheet\" >> tf2.md"
        "mods -f \"How to do n8n automation, explain the process , and write it to a file called n8n_groq_mods.md\" >> mods_groq_n8n.md"
        "mods -f \"Write a markdown file, that explains how to write AgentSkills whicih i can use with Gemini and OpenCode\" "
    )
    CMDMF=${MFC[3]}
    echo -e "${CYAN}---AI MODULE START---${NC}"
    echo -e "${BLUE}Executing: $CMDMF ${NC}"
    eval "$CMDMF"
    echo -e "${RED}---AI MODULE END---${NC}"
)

# Gemini Cli Commands - note you cannot use it this way

gm1() (
    declare -a MFC=(
        "gemini \"Write a terraform cheatsheet to be used in production\" >> gm_tf1.md"
    )
    CMDMF=${MFC[0]}
    echo -e "${CYAN}---AI MODULE START---${NC}"
    echo -e "${BLUE}Executing: $CMDMF ${NC}"
    eval "$CMDMF"
    echo -e "${RED}---AI MODULE END---${NC}"
)

# Open Code Commands
op1() (
    declare -a MFC=(
        "opencode web"                     # Open Web Interface
        "opencode auth list"               # List auth for LLm service providers
        "curl https://models.dev/api.json" # Accessing models via cli on models.dev from opencode
    )
    CMDMF=${MFC[2]}
    echo -e "${CYAN}---AI MODULE START---${NC}"
    echo -e "${BLUE}Executing: $CMDMF ${NC}"
    eval "$CMDMF"
    echo -e "${RED}---AI MODULE END---${NC}"
)

# --- Commands ---

# Execution ZOne
# s1
mf1
# gm1
# op1
