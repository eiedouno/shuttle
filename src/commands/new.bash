create_layout() {
    mkdir -p "$working_directory/src"
    touch "$working_directory/$PROJECT_NAME"
    touch "$working_directory/src/main.bash"
    touch "$working_directory/shuttle.json"
}

write_templates() {
    source ./lib/texts/template_start.bash >"$working_directory/$PROJECT_NAME"
    source ./lib/texts/template_main.bash >"$working_directory/src/main.bash"
    source ./lib/texts/template_json.bash >"$working_directory/shuttle.json"
    failsafe chmod +x "$working_directory/$PROJECT_NAME"
}

if [[ -z "$1" ]]; then
    epln "No directory specified." "Try 'shuttle help new'"
    exit 1
fi

working_directory="$(realpath -- "$1")"
plnv "${C_B}Creating directory $C_G$working_directory\n"
PROJECT_NAME="${working_directory##*/}"
plnv "${C_B}Project name set: $C_G$PROJECT_NAME\n"

if [[ "$FORCE" != "true" ]]; then
    if [[ "$1" == "." ]]; then
        plnq "${C_ERR}Override current directory? [y/N]"
        if ! yn_prompt; then
            exit 1
        fi
    elif [[ -d "$working_directory" ]]; then
        plnq "${C_ERR}Directory '$working_directory' already exists! Write anyway? [y/N]"
        if ! yn_prompt; then
            exit 1
        fi
    fi
fi

failsafe create_layout
failsafe write_templates
plnq "${C_G}Created project: $PROJECT_NAME ${C_LHT}| $working_directory\n"
