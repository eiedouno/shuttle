main() {
    local inst=$(jq -r ".${1}" "$ssl" 2>/dev/null || xx_failed)
    if [[ "$inst" == "null" ]]; then
	epln "Unknown package: $*." "Try updating the Shuttle Script Library. ('shuttle -y')"
	exit 1
    fi

    mkdir -p "$HOME/.cache/shuttle/downloads" || xx_failed
    cd "$HOME/.cache/shuttle/downloads" || xx_failed
    rm -rf "$1" > /dev/null || xx_failed
    git clone -q "$inst" || xx_failed
    source ./src/install.bash "$1"
    rm -rf "$1" >/dev/null || xx_failed
}

if [[ -f "$ssl" ]]; then
    main "$@"
else
    epln "Shuttle Script Library does not exist, updating..." ""
    source ./src/update_l.bash
    main "$@"
fi
