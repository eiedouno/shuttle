main() {
    if [[ $# == 0 ]]; then
	printf "\e[31mNo Directory Specified.\n\e[34mTry \'shuttle help new\'\n\e[0m"
    fi

    dir="$(realpath $1)"
    name="$(basename $dir)"

    create_layout
    template
    printf "\e[34mCreated new project: $name\n\e[0m"
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
