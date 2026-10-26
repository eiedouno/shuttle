add() {
    local work_directory="$HOME/.cache/shuttle/downloads"
    ssl_fetch "$1"

    failsafe mkdir -p "$working_directory/lib/$1/"
    failsafe cp -rf "$work_directory/$1/" "$working_directory/lib/$1/"

    if jq --arg v "$1" '.deps //= [] | .deps += [$v] | .deps |= unique' "$working_directory/shuttle.json" >"$working_directory/.shuttle.json"; then
        mv -f "$working_directory/.shuttle.json" "$working_directory/shuttle.json"
    else
        epln "Failed adding project to the shuttle.json file." "Add $1 to the '${C_G}deps${C_B}' array manually or retry"
    fi
}

source ./src/ssl/common.bash

[[ -z "$*" ]] && epln "Specify a library to add" "Try 'shuttle help add'" && exit 1
get_working_dir

for projectid in "$@"; do
    ssl_verify_id "$projectid" || exit 1
    add "$projectid"
    plnq "${C_G}Successfully added $projectid to this project\n"
done
