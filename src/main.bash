main() {
    shuttle_version="0.0.1"
    cols=$(tput cols)
    rows=$(tput lines)
    source ./src/param_h.bash "$@"
}

main "$@"
