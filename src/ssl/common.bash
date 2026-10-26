ssl_verify_id() {
    local project="$1"
    local query="$(jq -r --arg k "$project" '.[$k]' "$ssl" 2>/dev/null)"
    if [[ "$query" == "null" ]]; then
        epln "Unknown package: ${C_G}$project" "Try updating the Shuttle Script Library: 'shuttle -y'"
        return 1
    else
        plnv "${C_G}Found package at: ${C_P}$query\n"
    fi
}

ssl_install() {
    local projectid
    local work_directory="$HOME/.cache/shuttle/downloads"
    for projectid in "$@"; do
        ssl_verify_id "$projectid" || exit 1
        ssl_fetch "$projectid"
        VERBOSE=false source ./src/commands/install.bash "$work_directory/$projectid"
    done
}

ssl_fetch() {
    local project="$1"
    local is_url
    if [[ -z "$project" ]]; then
        epln "Attempted to fetch a null SSL entry" "Change how your command is worded"
    elif [[ "$project" == "__url" ]]; then
        shift
        is_url="true"
    fi

    local work_directory="$HOME/.cache/shuttle/downloads"

    if [[ "$is_url" != "true" ]]; then
        local query="$(jq -r --arg k "$project" '.[$k]' "$ssl" 2>/dev/null)"

        [[ "$query" == "null" ]] && {
            epln "SSL Query failed" "Try updating shuttle: 'shuttle -u'"
            exit 1
        }
    else
        local query="$1"

        [[ -z "$query" ]] && {
            epln "No url found" "Something weird happened, try re-wording your command"
            exit 1
        }
    fi

    failsafe mkdir -p "$work_directory"

    rm -rf "${work_directory:?}/${project:?}"

    failsafe git clone -q "$query" "${work_directory:?}/${project:?}"
}

if ! [[ -f "$ssl" ]]; then
    epln "Shuttle Script Library doesn't exist" "Updating"
    source ./src/update_ssl.bash
fi
