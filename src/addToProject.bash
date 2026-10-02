addMgr() {
    PREVDIR="$PWD"
    get_working_dir
    [[ -z "$*" ]] && epln "Specify a library to add." "Try 'shuttle help add'." && exit 1
    ssl_query_id "$@"
    for f in "$@"; do
        add "$f"
        pln "${C_G}Successfully added $f to this project.\n"
    done
}

add() {
    ssl_fetch "$1"
    cd "$1" || handleFailed
    mkdir -p "$workingDir/lib/$1" || handleFailed
    for lib in *.bash; do
        cp -rf "$lib" "$workingDir/lib/$1/" || handleFailed
    done

    jq --arg v "$1" '.deps //= [] | .deps += ([$v] - .deps)' "$workingDir/shuttle.json" >"$workingDir/.shuttle.json" && mv -f "$workingDir/.shuttle.json" "$workingDir/shuttle.json" || handleFailed
    cd "$PREVDIR" || handleFailed
}

if [[ -f "$ssl" ]]; then
    addMgr "$@"
else
    epln "Shuttle Script Library does not exist, updating..." ""
    source ./src/update_l.bash
    addMgr "$@"
fi
