remove() {
    local project="$1"
    local depname="$1"

    if [[ "$project" == *://* ]]; then
        depname="${project##*/}"
    fi

    if [[ -z "$depname" ]]; then
        epln "Couldn't resolve ${C_G}$project${C_ERR}" "If it is a url, don't keep the trailing '/'"
        exit 1
    fi

    local deppath="${working_directory:?}/lib/${depname:?}"

    if [[ -d "$deppath" ]]; then
        if [[ "$FORCE" != "true" ]]; then
            plnq "${C_ERR}Are you sure you want to remove $project? [y/N]"
            if ! yn_prompt; then
                return 1
            fi
        fi

        rm -rf "$deppath" || {
            epln "Failed removing $project from this project" "If this doesn't work you can remove the\n$C_G$deppath$C_B directory\nand remove the entry from the ${C_G}deps$C_B array in ${C_G}shuttle.json$C_B\n\nPlease make a issue on github!"
            return 1
        }

        jq --arg name "$depname" '
            .deps |= map(select(
            . != $name and
            (endswith("/" + $name) | not)
            ))
        ' "$working_directory/shuttle.json" >"$working_directory/.shuttle.json" && mv -f "$working_directory/.shuttle.json" "$working_directory/shuttle.json" || {
            epln "Failed updating ${C_G}shuttle.json${C_ERR}" "Remove ${C_G}$project${C_B} from the ${C_G}deps${C_B} array manually or retry"
            return 1
        }

    else
        epln "Library ${C_G}$project${C_ERR} is not installed"
        return 1
    fi
}

if [[ "$#" -eq 0 ]]; then
    epln "Specify a library to remove"
    exit 1
fi

source ./src/ssl/common.bash

get_working_dir

for projectid in "$@"; do
    if remove "$projectid"; then
        plnq "${C_G}Successfully removed $projectid from this project\n"
    else
        epln "Failed removing $projectid"
        did_fail=1
    fi
done

if [[ "$did_fail" == 1 ]]; then
    exit 1
fi
