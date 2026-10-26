remove() {
    if [[ -d "$working_directory/lib/$1" ]]; then
        if [[ "$FORCE" != "true" ]]; then
            plnq "${C_ERR}Are you sure you want to remove $1? [y/N]"
            if ! yn_prompt; then
                exit 1
            fi
        fi

        rm -rf "${working_directory:?}/lib/$1" || {
            epln "Failed removing $1 from this project" "If this doesn't work, you can remove the ${C_G}deps${C_B} entry inside ${C_G}shuttle.json${C_B} and remove the ${C_G}/lib/$1${C_B} directory"
        }

        jq --arg v "$1" '.deps //= [] | .deps -= [$v] | .deps |= unique' "$working_directory/shuttle.json" >"$working_directory/.shuttle.json" && mv -f "$working_directory/.shuttle.json" "$working_directory/shuttle.json" || handleFailed

    else
        epln "Library $C_G$1$C_ERR is not installed"
        exit 1
    fi
}

source ./src/ssl/common.bash

get_working_dir

for projectid in "$@"; do
    remove "$projectid"
    plnq "${C_G}Successfully removed $projectid from this project\n"
done
