source ./src/ssl/common.bash

is_ssl_project() {
    [[ -n "$1" && "$1" != ./* ]] && ssl_verify_id "$1" >/dev/null
}

remote_install() {
    local url
    local work_directory="$HOME/.cache/shuttle/downloads"
    for url in "$@"; do
        ssl_fetch __url "$url"
        VERBOSE=false source ./src/commands/install.bash "$work_directory/__url"
    done
}

get_project() {
    [[ -n "$1" && "$1" != ./* ]] && plnv "${C_Y}Querying SSL for project id: '${C_G}$1${C_Y}'\n"

    if is_ssl_project "$1"; then
        ssl_install "$@"
        exit 0
    elif [[ -d "$1" || -z "$1" ]]; then
        [[ -n "$1" && "$1" != ./* ]] && plnv "${C_Y}Failed to find a matching id, using directory matching!\n"
        plnv "${C_P}Installing from project inside: $C_G${1:-$PWD}\n"

        if [[ "$LINK" == "true" ]]; then
            get_working_dir "$1"
            source ./src/commands/build/check.bash
        else
            VERBOSE=false source ./src/commands/build.bash "$1"
        fi
    elif [[ "$1" =~ ^https:// ]]; then
        [[ -n "$1" && "$1" != ./* ]] && plnv "${C_Y}Failed to find a matching id, using directory matching!\n"
        plnv "${C_P}Found url! Resolving with git\n"

        remote_install "$@"
        exit 0
    else
        epln "Unknown project: $1" "Try 'shuttle help install'"
        exit 1
    fi
}

eval_destfile() {
    USER_ID="$(id -u)"

    if [[ "$USER_ID" == "0" ]]; then
        dest_file="/usr/local/bin/$PROJECT_NAME"
    else
        dest_file="$HOME/.local/bin/$PROJECT_NAME"
    fi
}

install_destfile() {
    if [[ -f "$dest_file" && "$FORCE" != "true" ]]; then

        plnq "${C_ERR}Overwrite $dest_file? [y/N]"
        if ! yn_prompt; then
            exit 1
        fi

        plnqa "\e[1G\e[2K"

    fi

    if [[ "$LINK" == "true" ]]; then
        source ./lib/texts/link.bash >"$dest_file"
    else
        failsafe cp -f "$outfile" "$dest_file"
    fi
}

get_project "$@"
eval_destfile
install_destfile

plnq "${C_G}Successfully installed $PROJECT_NAME${C_LHT} $dest_file\n"
