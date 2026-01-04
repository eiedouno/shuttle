main() {
    shuttle_version="0.0.3"
    initvars
    source ./src/param_h.bash "$@"
}

initvars() {
    rows=$(tput lines)
    cols=$(tput cols)

    # ANSI escape sequences for colors and formatting.
    C_G='\e[32m'
    C_R='\e[31m'
    C_B='\e[34m'
    C_P='\e[35m'
    C_RS='\e[0m'
    C_BLD='\e[1m'
    C_ERR='\e[31m\e[1m'
}

main "$@"
