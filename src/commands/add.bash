add() {
    local work_directory="$HOME/.cache/shuttle/downloads"
    local depname="$1"

    if [[ "$1" == *://* ]]; then
        ssl_fetch __url "$1"
        depname=${1##*/}
    else
        ssl_fetch "$1"
    fi

    if [[ -z "$depname" ]]; then
        epln "Failed to resolve ${C_G}$1" "If it is a url, don't keep the trailing '/'"
        return 1
    fi

    failsafe mkdir -p "$working_directory/lib/"

    if [[ -d "$working_directory/lib/$depname" ]]; then
        if [[ "$FORCE" != "true" ]]; then
            plnq "${C_Y}WARNING! '$C_G$working_directory/lib/$depname$C_Y' already exists! Overwrite? [y/N]"
            if ! yn_prompt; then
                exit 1
            fi
        fi

        failsafe rm -rf "${working_directory:?}/lib/${depname:?}"
    fi

    failsafe cp -rf "$work_directory/$1" "$working_directory/lib/$depname"

    if jq --arg v "$1" '.deps //= [] | .deps += [$v] | .deps |= unique' "$working_directory/shuttle.json" >"$working_directory/.shuttle.json"; then
        mv -f "$working_directory/.shuttle.json" "$working_directory/shuttle.json"
    else
        epln "Failed adding project to the shuttle.json file" "Add ${C_G}$1${C_B} to the '${C_G}deps${C_B}' array manually or retry"
    fi
}

source ./src/ssl/common.bash

[[ -z "$*" ]] && epln "Specify a library to add" "Try 'shuttle help add'" && exit 1
get_working_dir

for projectid in "$@"; do
    if [[ "$projectid" != *://* ]]; then
        ssl_verify_id "$projectid" || exit 1
    fi

    if add "$projectid"; then
        plnq "${C_G}Successfully added $projectid to this project\n"
    fi
done
