main() {
    if [[ -z "$1" ]]; then
        epln "No directory specified." "Try 'shuttle help new'"
        exit 1
    fi

    dir="$(realpath "$1")"
    name="$(basename "$dir")"

    if [[ -d "$dir" ]]; then
        printf "%b" "${C_ERR}Directory '$dir' already exists, override? (y/n)"
        read -rn1 ans
        if [[ "$ans" == "y" ]]; then
            plnq "\e[2K\e[1G\e[0m"
        else
            epln "Denied. Stopping..."
            exit 1
        fi
    fi

    create_layout || xx_failed
    template
    pln "${C_B}Created new project: $name\n$C_RS"
}

create_layout() {
    mkdir -p "$dir/src"
    touch "$dir/$name"
    touch "$dir/src/main.bash"
    touch "$dir/shuttle.json"
}

template() {
    source ./lib/texts/template_start.bash >"$dir/$name"
    source ./lib/texts/template_main.bash >"$dir/src/main.bash"
    source ./lib/texts/template_json.bash >"$dir/shuttle.json"
    chmod +x "$dir/$name"
}

main "$@"
