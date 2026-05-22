main() {
    PREVDIR="$PWD"
    get_acting_dir
    [[ -z "$*" ]] && epln "Specify a library to add." "Try 'shuttle help add'." && exit 1
    ssl_query_id "$@"
    for f in "$@"; do
        add "$f"
        pln "${C_G}Successfully added $f to this project.\n"
    done
}

add() {
    ssl_fetch "$1"
    cd "$1" || xx_failed
    mkdir -p "$dir/lib/$1" || xx_failed
    for lib in *.bash; do
        cp -rf "$lib" "$dir/lib/$1/" || xx_failed
    done

    jq --arg v "$1" '.deps //= [] | .deps += ([$v] - .deps)' "$dir/shuttle.json" >"$dir/.shuttle.json" && mv -f "$dir/.shuttle.json" "$dir/shuttle.json" || xx_failed
    cd "$PREVDIR" || xx_failed
}

if [[ -f "$ssl" ]]; then
    main "$@"
else
    epln "Shuttle Script Library does not exist, updating..." ""
    source ./src/update_l.bash
    main "$@"
fi
