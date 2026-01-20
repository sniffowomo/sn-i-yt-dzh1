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

# Booty

smell_fart() {
    cat <<'EOF'
⠄⠄⠸⣿⣿⢣⢶⣟⣿⣖⣿⣷⣻⣮⡿⣽⣿⣻⣖⣶⣤⣭⡉⠄⠄⠄⠄⠄
⠄⠄⠄⢹⠣⣛⣣⣭⣭⣭⣁⡛⠻⢽⣿⣿⣿⣿⢻⣿⣿⣿⣽⡧⡄⠄⠄⠄
⠄⠄⠄⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣶⣌⡛⢿⣽⢘⣿⣷⣿⡻⠏⣛⣀⠄⠄
⠄⠄⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠙⡅⣿⠚⣡⣴⣿⣿⣿⡆⠄
⠄⠄⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠄⣱⣾⣿⣿⣿⣿⣿⣿⠄
⠄⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⠄
⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠣⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄
⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠑⣿⣮⣝⣛⠿⠿⣿⣿⣿⣿⠄
⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠄⠄⠄⠄⢹⣿⣿⣿⣿⣿⣿⣿⣿⠁⠄
⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠄⠄⠄⠄⠄⠸⣿⣿⣿⣿⣿⡿⢟⣣⣀
EOF
}

# Run each command one by one
run1() {
    declare -a CMD=(
        "uv run e2e_cli --help"
        "e2e_cli --help"
        "e2e_cli alias view"
        "e2e_cli alias --help"
        "e2e_cli alias add"  # Adding panty
        "e2e_cli alias view" # View
        "e2e_cli node list"  # List all nodes, comes as a json file

    )
    CMDEXEC="${CMD[6]}"
    echo -e "${BBLUE} · · ────── ꒰ঌ·✦·໒꒱ ────── · ·"
    date && smell_fart
    echo -e "Executing:${RESET} ${CMDEXEC}"
    eval "${CMDEXEC}"
    echo -e "${BGREEN}Done!"
    echo -e "───── ⋆⋅☆⋅⋆ ─────${RESET}"
}

#  All commands executed inside array
runc() {
    declare -a CMD=(
        "uv run e2e_cli --help"
    )

    for CMDEXEC in "${CMD[@]}"; do
        echo -e "${BBLUE}────── ꒰ঌ·✦·໒꒱ ──────${RESET}"
        echo -e "Executing: ${CMDEXEC}"
        eval "${CMDEXEC}"
        echo -e "${BGREEN}Done!${RESET}"
        echo -e "${BBLUE}───── ⋆⋅☆⋅⋆ ─────${RESET}"
        echo # Add blank line between commands
    done
}

# /////////////////////////////

# -- Execution Blocks ---
panty() {
    run1 # Run one command at one time
    # runc  # Run all commands in array
}

# Main Execution
panty
