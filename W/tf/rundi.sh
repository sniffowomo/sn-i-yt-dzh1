#!/usr/bin/env bash
# TF related commands dump

set -euo pipefail

# --- Colors ---
BBLACK='\033[1;90m'
BRED='\033[1;91m'
BGREEN='\033[1;92m'
BYELLOW='\033[1;93m'
BBLUE='\033[1;94m'
BMAGENTA='\033[1;95m'
BCYAN='\033[1;96m'
BWHITE='\033[1;97m'
RESET='\033[0m'

# --- Commands ---

# All comands will be in an array and executed as needed single command
t1() {
    declare -a CMD=(
        # Installing terraform from manual

    )
    CMDEXEC="${CMD[0]}"
    echo -e "${BBLUE}Executing:${RESET} ${CMDEXEC}"
    eval "${CMDEXEC}"
    echo -e "${BGREEN}Done!${RESET}"
}

# Initial group command executed for installation
t2() {
    echo -e "${BBLUE}--- Installing Terraform ---${RESET}"
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
    echo -e "${BGREEN}---Terraform installed successfully!---${RESET}"
}

# -- Execution ---
t2
