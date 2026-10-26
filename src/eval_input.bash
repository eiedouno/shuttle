expand_options() {
    local char
    local str="$1"
    local i=0

    while [[ $i -lt ${#str} ]]; do
        char="${str:$i:1}"
        [[ -z "$char" ]] && continue
        eval_option "$char" "alias"
        ((i++))
    done

    remove_index ARGS "$index"
}

eval_option() {
    if [[ -n "${options[$1]}" ]]; then

        [[ "$2" != "alias" ]] && remove_index ARGS "$index"
        local link="${options[$1]}"

        # if the passed option is an alias
        if [[ -n "${options[$link]}" ]]; then
            source "${options[$link]}" ""
        else
            source "$link" ""
        fi

        evaled_command=2
    else
        eval_flag "$@"
    fi
}

verify_flags() {
    if [[ "$QUIET" == "true" && "$VERBOSE" == "true" ]]; then
        epln "Imagine setting QUIET and VERBOSE" "Thinking is a good idea btw..."
        exit 1
    fi
}

eval_flag() {
    if [[ -n "${flags[$1]}" ]]; then
        [[ "$2" != "alias" ]] && remove_index ARGS "$index"
        printf -v "${flags["$1"]}" "true"
    else
        epln "Option not known: '$1'" "Try 'shuttle -h'"
        exit 1
    fi

    verify_flags
}

eval_command() {
    remove_index ARGS "$index"
    if [[ -n "${commands[$1]}" ]]; then
        if [[ "${commands[$1]}" == "1" ]]; then
            command="./src/commands/$1.bash"
        else
            command="./src/commands/${commands[$1]}.bash"
        fi
    else
        epln "Command not known: '$1'" "Try 'shuttle -h'"
        exit 1
    fi

    evaled_command=1
}

no_command() {
    epln "Command not specified" "Try 'shuttle -h'"
    exit 1
}

evaluate_arguments() {
    local arg
    local index=0

    for arg in "$@"; do

        if [[ -z "$arg" ]]; then
            :
        elif [[ "$arg" == "--" ]]; then
            break
        elif [[ "$arg" == --* ]]; then
            arg="${arg#--}"
            [[ -n "$arg" ]] && eval_option "$arg"
        elif [[ "$arg" == -* ]]; then
            arg="${arg#-}"
            [[ -n "$arg" ]] && expand_options "$arg"
        elif [[ -z "$evaled_command" ]]; then
            eval_command "$arg"
        fi

        ((index++))
    done

    # printf '%b' "output args: ${ARGS[*]}\nforce: $FORCE\nquiet: $QUIET\nverbose: $VERBOSE\nlink: $LINK\nslow: $SLOW\n"
    if [[ -n "$command" && "$evaled_command" != "2" ]]; then
        set -- "${ARGS[@]}"
        source "$command" "$@"
    fi

    [[ -z "$evaled_command" ]] && no_command

    # For an unknown reason, this function always returns 1, make it return 0
    return 0
}

handle_cli_command() {
    if [[ -z "${commands[$1]}" ]]; then
        if command -v "$1" >/dev/null; then
            eval "$@"
        else
            near="$(printf '%s\n' "$PATH_COMMANDS" | rg -e "$1")"
            epln "\n\e[1A\e[14C^\e[$((${#1} - 1))b $C_B--- ${C_P}Command not known" "${near:+"help: similar commands exist:"} ${near//$'\n'/ }"
            exit 1
        fi

    else
        evaluate_arguments "$@"
    fi
}

# Set ARGS to the inputted arguments
read -ra ARGS <<<"$@"

if [[ "$#" == "0" ]]; then
    no_command
fi

if [[ "$CLI" == "1" ]]; then
    handle_cli_command "$@"
else
    evaluate_arguments "$@"
fi
