main() {
    local inst=$(jq -r ".${1}" "$ssl")
    local tmppwd="$PWD"

    mkdir -p "$HOME/.cache/shuttle/downloads"
    cd "$HOME/.cache/shuttle/downloads"
    rm -rf "$1" > /dev/null
    git clone -q "$inst"
    source ./src/install.bash "$1"
}

if [[ -f "$ssl" ]]; then
    main "$@"
else
    printf "${C_ERR}Shuttle Script Library does not exist, updating...\n${C_RS}"
    source ./src/update_l.bash
    main "$@"
fi
