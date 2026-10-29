if [[ -f "$working_directory/shuttle.json" ]]; then
    plnv "${C_Y}Fetching project details!\n"
    ConvertFrom-JSON "$working_directory/shuttle.json"

    get_project_type
    PROJECT_SHELL="${shuttle_json[shell]:-"bash"}"
    PROJECT_ID="${shuttle_json[id]}"
    PROJECT_NAME="${shuttle_json[name]:-"${working_directory##*/}"}"
    [[ "$PROJECT_TYPE" == "library" ]] && epln "Libraries aren't buildable." "If this isn't a library, set '${C_G}type${C_B}' to '${C_G}script${C_B}' inside '${C_G}shuttle.json${C_B}'" && exit 1
    [[ -z "$PROJECT_ID" ]] && epln "This build doesn't have an id." "Add the '${C_G}id${C_B}' key inside '${C_G}shuttle.json${C_B}'" && exit 1

    declare -A allowed_shells=(
        [sh]=1
        [bash]=1
        [zsh]=1
    )

    if [[ "${allowed_shells["$PROJECT_SHELL"]}" != "1" ]]; then
        epln "Invalid shell: $PROJECT_SHELL" "The shells you can use are '${C_G}sh${C_B}' '${C_G}bash${C_B}' or '${C_G}zsh${C_B}'\nIf this isn't your project, report this to the authors"
        exit 1
    fi

    plnv "${C_B}Project name: ${C_G}$PROJECT_NAME${PROJECT_ID:+" ($PROJECT_ID)"}${C_RS}\n${C_B}Project type: ${C_G}$PROJECT_TYPE\n\n"
else
    PROJECT_NAME="${working_directory##*/}"
fi
