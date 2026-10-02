new() {
    if [[ -z "$1" ]]; then
        epln "No directory specified." "Try 'shuttle help new'"
        exit 1
    fi

    workingDir="$(realpath "$1")"
    projectName="$(basename "$workingDir")"

    if [[ -d "$workingDir" ]]; then
        printf "%b" "${C_ERR}Directory '$workingDir' already exists, override? (y/n)"
        read -rn1 ans
        if [[ "$ans" == "y" ]]; then
            plnqa "\e[2K\e[1G\e[0m"
        else
            epln "Denied. Stopping..."
            exit 1
        fi
    fi

    create_layout || handleFailed
    template
    pln "${C_B}Created new project: $projectName\n$C_RS"
}

create_layout() {
    mkdir -p "$workingDir/src"
    touch "$workingDir/$projectName"
    touch "$workingDir/src/main.bash"
    touch "$workingDir/shuttle.json"
}

template() {
    source ./lib/texts/template_start.bash >"$workingDir/$projectName"
    source ./lib/texts/template_main.bash >"$workingDir/src/main.bash"
    source ./lib/texts/template_json.bash >"$workingDir/shuttle.json"
    chmod +x "$workingDir/$projectName"
}

new "$@"
