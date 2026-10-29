ConvertFrom-JSON() {
    local jsonfile="$1"
    local jsonfilenam
    jsonfilename=${jsonfile##*/}
    local varname="${jsonfilename//./_}"

    if [[ ! "$varname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        epln "Bad derived variable name: $varname is invalid\n" "Report this to the authors of the project"
        exit 1
    fi

    declare -gA "$varname"
    declare -n arr="$varname"

    while IFS= read -r -d '' key && IFS= read -r -d '' value; do
        [[ -n "$key" ]] || continue
        arr["$key"]="$value"
    done < <(jq -j 'to_entries[] | .key, "\u0000", (.value | tostring), "\u0000"' "$jsonfile" 2>/dev/null) || {
        epln "Failed to parse JSON file ${C_G}$jsonfile\n" "Report this to the authors of the project"
        exit 1
    }
}

check_deps() {
    local jsonfile="$1"
    local key="deps"
    local -a missing=()
    local entry

    # One jq call: only emit entries if "deps" exists and is an array
    while IFS= read -r -d '' entry; do
        # Skip empty entries
        [[ -n "$entry" ]] || continue

        # Basic user-proofing: reject path traversal / absolute paths
        if [[ "$entry" == *"/"* || "$entry" == *".."* || "$entry" == /* ]]; then
            epln "Invalid dependency name: ${C_G}$entry" "Dependency names must be SSL IDs\nIf this isn't your code, report this to the author"
            exit 1
        fi

        if [[ ! -d "$working_directory/lib/$entry" ]]; then
            missing+=("$entry")
        fi
    done < <(jq -j --arg k "$key" '
        if has($k) and (.[$k] | type == "array") then
            .[$k][]
        else
            empty
        end | ., "\u0000"
    ' "$jsonfile" 2>/dev/null)

    if ((${#missing[@]} > 0)); then
        local entryindex=0
        for entry in "${missing[@]}"; do
            sleep 1
            build_diff="Fetching dependencies: ${missing[*]:$entryindex}"
            build_progress=$((entryindex * 100 / ${#missing[@]}))
            progbar_update

            QUIET=true source ./src/commands/add.bash "$entry"
            ((entryindex++))
            sleep 1
        done
    fi
}

check_raw_deps() {
    local jsonfile="$1"
    local key="raw_deps"
    local -a missing=()
    local entry

    # One jq call: only emit entries if "raw_deps" exists and is an array
    while IFS= read -r -d '' entry; do
        # Skip empty entries
        [[ -n "$entry" ]] || continue

        # Basic user-proofing: reject anything that looks like a path or has spaces
        if [[ "$entry" == *"/"* || "$entry" == *".."* || "$entry" == *" "* || "$entry" == /* ]]; then
            epln "Invalid raw dependency: ${C_G}$entry" "Raw dependencies must be commands as they would be called from the shell\nIf this isn't your code, report this to the author"
            exit 1
        fi

        if ! command -v "$entry" >/dev/null 2>&1; then
            missing+=("$entry")
        fi
    done < <(jq -j --arg k "$key" '
        if has($k) and (.[$k] | type == "array") then
            .[$k][]
        else
            empty
        end | ., "\u0000"
    ' "$jsonfile" 2>/dev/null)

    if ((${#missing[@]} > 0)); then
        build_diff="${C_ERR}One or more dependencies not present"
        build_progress=100
        progbar_update

        plnqa '\n\n\n\e[0J'
        pln "${C_ERR}The following dependencies were not found on your system:\n"
        printf '%b\n' "${missing[@]}" ""
        pln "${C_B}Please install them with your package manager.\n$C_RS"
        exit 1
    fi
}

get_working_dir() {
    working_directory="${1:-$PWD}"
    working_directory="$(realpath -P "$working_directory")"
    local passed_directory="$working_directory"

    while ! [[ -f "$working_directory/src/main.bash" || -f "$working_directory/shuttle.json" ]]; do
        if [[ "$working_directory" == "/" ]]; then
            epln "Unable to find shuttle project in directory" "Make sure you've specified the path of your project ${C_LHT}you specified: ${C_G}$passed_directory"
            exit 1
        fi

        working_directory="${working_directory%/*}"
        [[ -z "$working_directory" ]] && working_directory="/"
    done
}

get_project_type() {
    declare -A allowed_types=(
        [script]=1
        [library]=1
    )

    if [[ -v shuttle_json[type] ]]; then
        PROJECT_TYPE="${shuttle_json[type]}"
        if ! [[ "${allowed_types["$PROJECT_TYPE"]}" ]]; then
            epln "Unknown project type specified" "Try setting '${C_G}type${C_B}' to '${C_G}script${C_B}' inside ${C_G}shuttle.json ${C_LHT}| you specified '$PROJECT_TYPE'"
            exit 1
        fi
    else
        if [[ -f "$working_directory/shuttle.json" ]]; then
            epln "${C_G}Type ${C_ERR}isn't speficied inside ${C_G}shuttle.json" "Add '${C_P}\"type\": \"script\"${C_B}' inside ${C_G}shuttle.json"
            exit 1
        else
            epln "${C_G}shuttle.json ${C_ERR}doesn't exist"
            exit 1
        fi
    fi
}

failed() {
    epln "An unknown error occured"
    exit 1
}

failsafe() {
    "$@" || {
        epln "Failed to run '$*'" "Try again?"
        exit 1
    }
}

copy_aarray() {
    local origin="$1"
    local temp

    temp="$(declare -p "$origin")"
    eval "declare -gA $2=${temp#*=}"
}

remove_index() {
    declare -n array=$1
    local index="$2"
    unset "array[$index]"
}

exit() {
    plnqa "\e[?25h"
    builtin exit "$1"
}

# Printf wrapper
pln() {
    printf "%b$C_RS" "$*"
}

# pln if not quiet
plnq() {
    [[ $QUIET != "true" ]] && pln "$@"
    return 0
}

# pln if verbose
plnv() {
    [[ "$VERBOSE" == "true" ]] && pln "$@"
    return 0
}

# pln if inside terminal
plna() {
    [[ -t 1 ]] && pln "$@"
    return 0
}

plnqa() {
    [[ $QUIET != "true" && -t 1 ]] && pln "$@"
    return 0
}

plnva() {
    [[ "$VERBOSE" == "true" && -t 1 ]] && pln "$@"
    return 0
}

# error output
epln() {
    printf "$C_ERR%b$C_RS$C_B%b\n$C_RS" "$1" "${2:+\n$2}"
}

yn_prompt() {
    local -f send_exit
    local -f send_ok

    send_exit() {
        plnqa "\e[2K\e[1G"
        epln "Confirmation check failed"
    }

    send_ok() {
        plnqa "\e[2K\e[1G"
    }

    [[ "$FORCE" == "true" && "$1" != "force" ]] && return 0
    [[ "$QUIET" == "true" && "$FORCE" != "true" ]] && send_exit && return 1

    declare ans
    read -rn1 ans

    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        send_ok
        return
    else
        send_exit
        return 1
    fi
}
