ConvertFrom-JSON() {
    local XXjsonfile="$1"
    local XXjsonfilename=$(basename "$1")

    for key in $(jq -r 'keys[]' "$XXjsonfile" 2>/dev/null); do
        local value
        value=$(jq -r --arg k "$key" '.[$k]' "$XXjsonfile" 2>/dev/null)

        local XXkeyname="${XXjsonfilename//./_}_$key"
        printf -v "$XXkeyname" '%s' "$value"
    done
}

ssl_query_id() {
    for project in "$@"; do
        local inst=$(jq -r --arg k "$project" '.[$k]' "$ssl" 2>/dev/null)
        if [[ "$inst" == "null" ]]; then
            epln "Unknown package: $*." "Try updating the Shuttle Script Library. ('shuttle -y')"
            exit 1
        fi
    done
}

ssl_install() {
    ssl_fetch "$1"
    cd "$1" || handleFailed
    source ./src/installProject.bash
    cd .. || handleFailed
    rm -rf "$1" >/dev/null || handleFailed
}

ssl_fetch() {
    local inst=$(jq -r --arg k "$1" '.[$k]' "$ssl" 2>/dev/null)
    [[ "$inst" == "null" ]] && handleFailed

    mkdir -p "$HOME/.cache/shuttle/downloads" || {
        epln "Failed to create directory: $HOME/.cache/shuttle/downloads" "Please ensure you have read-write permissions."
        exit 1
    }

    cd "$HOME/.cache/shuttle/downloads" || handleFailed
    rm -rf "$1" >/dev/null || handleFailed
    git clone -q "$inst" || handleFailed
}

get_working_dir() {
    if [[ -z "$workingDir" ]]; then
        workingDir="$(realpath "$PWD")"
    else
        workingDir="$(realpath "$workingDir")"
    fi

    projectName="$(basename "$workingDir")"

    if [[ -f "$workingDir/src/main.bash" || -f "$workingDir/shuttle.json" ]]; then
        return
    else
        if [[ "$workingDir" == "/" ]]; then
            epln "Unable to find shuttle project in directory." "Make sure you're inside the root of your project."
            exit 1
        fi
        cd .. || handleFailed
        workingDir="$(realpath "$(pwd)")"
        get_working_dir "$workingDir"
    fi
}

get_proj_type() {
    local file="$1"
    local key="type"

    if jq -e ".${key}" "$file" >/dev/null 2>&1; then
        PROJECT_TYPE=$(jq -r ".${key}" "$file" 2>/dev/null)
        if [[ $PROJECT_TYPE != "script" && $PROJECT_TYPE != "library" ]]; then
            epln "Project types are 'script' and 'library'. You specified $PROJECT_TYPE." "Hint: change 'type' inside 'shuttle.json' to 'script'." && exit 1
        fi
    else
        epln "You must specify the type of your project." "Hint: add '\"type\": \"script\"' to shuttle.json" && exit 1
    fi
}

deps_chk() {
    local file="$1"
    local key="deps"
    local fail
    local err

    if jq -e ".${key}" "$file" >/dev/null 2>&1; then
        while read -r entry; do
            if [[ ! -d "$workingDir/lib/$entry" ]]; then
                fail=1
                err+=("$entry")
            fi
        done < <(jq -r ".${key}[]" "$file" 2>/dev/null)
    fi

    if [[ "$fail" == "1" ]]; then

        pln "${C_B}Fetching dependencies:\n"
        printf '%b\n' "${err[@]}"

        for c in "${err[@]}"; do
            source ./src/addToProject.bash "$c"
        done
    fi
}

raw_deps_chk() {
    local file="$1"
    local key="raw_deps"
    local fail
    local err

    if jq -r ".${key}[]" "$file" >/dev/null 2>&1; then

        while read -r entry; do
            if ! command -v "$entry" >/dev/null; then
                fail=1
                err+=("$entry")
            fi
        done < <(jq -r ".${key}[]" "$file" 2>/dev/null)
    fi

    if [[ "$fail" == "1" ]]; then
        pln "${C_ERR}The following dependencies were not found on your system:\n"
        printf '%b\n' "${err[@]}"
        pln "${C_B}Please install them with your package manager.\n$C_RS"
        exit 1
    fi
}

ss() {
    [[ "$SLOW" == "true" ]] && sleep "0.01"
}

return
