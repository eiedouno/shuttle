main() {
    ssl_query_id "$@"
    for z in "$@"; do
	ssl_install "$z"
    done
}

if [[ -f "$ssl" ]]; then
    if [[ -n "$@" ]]; then
	main "$@"
    else
	epln "List something to install DX" && exit 1
    fi
else
    epln "Shuttle Script Library does not exist, updating..." ""
    source ./src/update_l.bash
    main "$@"
fi
