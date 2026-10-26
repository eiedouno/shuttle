eval_destfile_name() {
    if [[ -z "$1" ]]; then
        get_working_dir "$1"
        source ./src/commands/build/check.bash "."

        dest_file_name="$PROJECT_NAME"
    else
        dest_file_name="$1"
    fi
}

eval_destfile() {
    eval_destfile_name "$@"
    USER_ID="$(id -u)"

    if [[ "$USER_ID" == "0" ]]; then
        dest_file="/usr/local/bin/$dest_file_name"
    else
        dest_file="$HOME/.local/bin/$dest_file_name"
    fi
}

uninstall_destfile() {
    if [[ -f "$dest_file" ]]; then
        if [[ "$FORCE" != "true" ]]; then

            plnq "${C_ERR}Delete $dest_file? [y/N]"
            if ! yn_prompt; then
                exit 1
            fi

            plnqa "\e[1G\e[2K"
        fi
    else
        epln "$dest_file_name is not installed" && exit 1
    fi

    failsafe rm -f "$dest_file"
}

eval_destfile "$@"
uninstall_destfile

plnq "${C_G}Successfully uninstalled $dest_file_name${PROJECT_ID:+" ($PROJECT_ID)"}${C_LHT} $dest_file\n"
