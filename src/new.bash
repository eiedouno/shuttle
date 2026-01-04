main() {
    if [[ $# == 0 ]]; then
	printf "${C_ERR}No Directory Specified.$C_RS\n${C_B}Try \'shuttle help new\'\n$C_RS"
    fi

    dir="$(realpath $1)"
    name="$(basename $dir)"

    create_layout
    template
    printf "${C_B}Created new project: $name\n$C_RS"
}

create_layout() {
    mkdir -p "$dir/src"
    touch "$dir/$name"
    touch "$dir/src/main.bash"
}

template() {
    source ./lib/texts/template_start.bash > "$dir/$name"
    source ./lib/texts/template_main.bash > "$dir/src/main.bash"
    chmod +x "$dir/$name"
}

main "$@"
