main() {
    local inst=$(jq -r ".${1}" "$ssl")
    if [[ "$inst" == "null" ]]; then
	printf "${C_ERR}Unknown package: $@.$C_RS\n${C_B}Try updating the Shuttle Script Library. ('shuttle -y')\n$C_RS"
	exit 1
    fi

    mkdir -p "$HOME/.cache/shuttle/downloads"
    cd "$HOME/.cache/shuttle/downloads"
    rm -rf "$1" > /dev/null
    git clone -q "$inst"
    source ./src/install.bash "$1"
    rm -rf "$1" > /dev/null
}

if [[ -f "$ssl" ]]; then
    main "$@"
else
    printf "${C_ERR}Shuttle Script Library does not exist, updating...\n${C_RS}"
    source ./src/update_l.bash
    main "$@"
fi
