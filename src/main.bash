main() {
    if [[ $(id -u) == "0" ]]; then
        pln "\e[31m\e[1mRunning as ROOT is forbidden.\n"
        exit 1
    fi
    initvars
    source ./src/param_h.bash "$@"
}

initvars() {
    shuttle_version="1.0"
    ssl="$HOME/.cache/shuttle/ssl.json"
    rows=$(tput lines)
    cols=$(tput cols)

    # ANSI escape sequences for colors and formatting.
    C_G='\e[32m'
    C_R='\e[31m'
    C_Y='\e[33m'
    C_B='\e[34m'
    C_P='\e[35m'
    C_RS='\e[0m'
    C_BLD='\e[1m'
    C_LHT='\e[2m'
    C_ERR='\e[31m\e[1m'
}

ConvertFrom-JSON() {
    local XXjsonfile="$1"
    local XXjsonfilename=$(basename "$1")

    for key in $(jq -r 'keys[]' "$XXjsonfile"); do
        local value
        value=$(jq -r --arg k "$key" '.[$k]' "$XXjsonfile")

        local XXkeyname="${XXjsonfilename%*.*}_$key"
        printf -v "$XXkeyname" '%s' "$value"
    done
}

ssl_query_id() {
    for f in "$@"; do
        local inst=$(jq -r --arg k "$f" '.[$k]' "$ssl" 2>/dev/null)
        if [[ "$inst" == "null" ]]; then
            epln "Unknown package: $*." "Try updating the Shuttle Script Library. ('shuttle -y')"
            exit 1
        fi
    done
}

ssl_install() {
    ssl_fetch "$1"
    cd "$1" || xx_failed
    source ./src/install.bash
    cd .. || xx_failed
    rm -rf "$1" >/dev/null || xx_failed
}

ssl_fetch() {
    local inst=$(jq -r --arg k "$1" '.[$k]' "$ssl" 2>/dev/null)
    [[ "$inst" == "null" ]] && xx_failed
    mkdir -p "$HOME/.cache/shuttle/downloads" || xx_failed
    cd "$HOME/.cache/shuttle/downloads" || xx_failed
    rm -rf "$1" >/dev/null || xx_failed
    git clone -q "$inst" || xx_failed
}

xx_failed() {
    epln "An unknown error occurred."
    exit 1
}

get_acting_dir() {
    if [[ -z "$dir" ]]; then
        dir="$(realpath "$PWD")"
    else
        dir="$(realpath "$dir")"
    fi

    name="$(basename "$dir")"

    if [[ -f "$dir/src/main.bash" || -f "$dir/shuttle.json" ]]; then
        return
    else
        if [[ "$dir" == "/" ]]; then
            epln "Unable to find shuttle project in directory." "Make sure you're inside the root of your project."
            exit 1
        fi
        cd .. || xx_failed
        dir="$(realpath "$(pwd)")"
        get_acting_dir "$dir"
    fi
}

# Printf handler
pln() {
    local safe=${*//%/%%}
    printf '%b\e[0m' "$safe"
}

# Print, but for quiet
plnq() {
    if [[ $QUIET != "true" ]]; then
        pln "$@"
    fi
}

# Error output
epln() {
    local safe1=${1//%/%%}
    local safe2=${2//%/%%}
    printf "\n\e[31m\e[1m%b\e[0m\n\e[34m%b\n\e[0m" "$safe1" "$safe2"
}

get_proj_type() {
    local file="$1"
    local key="type"

    if jq -e ".${key}" "$file" >/dev/null 2>&1; then
        PROJECT_TYPE=$(jq -r ".${key}" "$file")
        if [[ $PROJECT_TYPE != "script" && $PROJECT_TYPE != "library" ]]; then
            epln "Project types are 'script' and 'library'. You specified $PROJECT_TYPE." "Hint: change 'type' inside 'shuttle.json' to 'script'." && exit 1
        fi
    else
        epln "You must specify the type of your project." && exit 1
    fi
}

deps_chk() {
    local file="$1"
    local key="deps"
    local fail
    local err

    if jq -e ".${key}" "$file" >/dev/null 2>&1; then
        while read -r entry; do
            if [[ ! -d "$dir/lib/$entry" ]]; then
                fail=1
                err+=("$entry")
            fi
        done < <(jq -r ".${key}[]" "$file")
    fi

    if [[ "$fail" == "1" ]]; then

        pln "${C_B}Fetching dependencies:\n"
        printf '%b\n' "${err[@]}"

        for c in "${err[@]}"; do
            source ./src/add.bash "$c"
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
        done < <(jq -r ".${key}[]" "$file")
    fi

    if [[ "$fail" == "1" ]]; then
        pln "${C_ERR}The following dependencies were not found on your system:\n"
        printf '%b\n' "${err[@]}"
        pln "${C_B}Please install them with your package manager.\n$C_RS"
        exit 1
    fi
}

main "$@"
