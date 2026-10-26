cli() {
    if [[ "$CLI" == "1" && "$FORCE" != "true" ]]; then
        pln "\n$C_Y${C_BLD}WARNING: ${C_B}CLI instance already exists, continue? ${C_LHT}[y/N] "
        if ! yn_prompt; then
            exit 1
        fi

        pln "\n"
    fi

    pln "${C_P}Starting Shuttle CLI...\n"
    CLI=1
    PATH_COMMANDS="$(compgen -c)"

    ans=0
    while true; do
        prompt
        evaluate
    done
}

prompt() {
    declare buffer
    if [[ -z "$ans" ]]; then
        buffer="\e[1A\e[2K\e[1B"
    else
        buffer="\n${C_B}   - $PWD -\n"
    fi

    buffer+="${C_P}   shuttle ${C_Y}>_ ${C_RS}"
    printf '%b' "$buffer"
}

evaluate() {
    failsafe read -ra ans

    if [[ -z "${ans[*]}" ]]; then
        return
    fi

    case "${ans[0]}" in
    exit)
        exit 0
        ;;

    clear)
        printf "\e[3J\e[2J\e[0H"
        return
        ;;

    cd*)
        cd "${ans[1]}" >/dev/null 2>&1 || epln "No such directory '${ans[1]}'"
        return
        ;;
    esac

    trap 'return' INT
    (
        source ./src/eval_input.bash "${ans[@]}"
    )
}

shift
[[ ! -t 0 ]] && epln "Not in a terminal (stdin)" && exit 1
[[ ! -t 1 ]] && epln "Not in a terminal (stdout)" && exit 1

cli
