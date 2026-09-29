main() {
    initiateVars
    source ./src/common.bash
    source ./src/param_h.bash "$@"
    plnqa "\e[?25h"
}

trap 'printf >&2 "\e[?25h"; exit 1' SIGINT SIGTERM

initiateVars() {
    shuttle_version="5.3"
    ssl="$HOME/.cache/shuttle/ssl.json"

    # ANSI escape sequences for colors and formatting.
    if [[ ! -t 1 ]]; then
        C_G=''
        C_R=''
        C_Y=''
        C_B=''
        C_P=''
        C_RS=''
        C_BLD=''
        C_LHT=''
        C_ERR=''
    else
        C_G='\e[32m'
        C_R='\e[31m'
        C_Y='\e[33m'
        C_B='\e[34m'
        C_P='\e[35m'
        C_RS='\e[0m'
        C_BLD='\e[1m'
        C_LHT='\e[2m'
        C_ERR='\e[31m\e[1m'
    fi
}

handleFailed() {
    epln "An unknown error occurred."
    exit 1
}

exit() {
    plnqa "\e[?25h"
    builtin exit "$1"
}

# Printf handler
pln() {
    printf "%b$C_RS" "$*"
}

# Print, but for quiet
plnq() {
    if [[ $QUIET != "true" ]]; then
        pln "$@"
    fi
}

plna() {
    [[ -t 1 ]] && pln "$@"
}

plnqa() {
    [[ $QUIET != "true" && -t 1 ]] && pln "$@"
}

plnv() {
    [[ "$VERBOSE" == "true" ]] && pln "$@"
}

plnva() {
    [[ "$VERBOSE" == "true" && -t 1 ]] && pln "$@"
}

# Error output
epln() {
    local safe1=${1//%/%%}
    local safe2=${2//%/%%}
    printf "\n$C_ERR%b$C_RS\n$C_B%b\n$C_RS" "$safe1" "$safe2"
}

main "$@"
