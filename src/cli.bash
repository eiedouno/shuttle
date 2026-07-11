shift
[[ ! -t 1 ]] && epln "Not in a terminal." && exit 1

main() {
    if [[ "$CLI" == "1" ]]; then
        pln "\n${C_Y}${C_BLD}WARNING: ${C_B}CLI instance already exists, continue? (y/n)"
        read -rn1 ans
        if [[ "$ans" == "y" ]]; then
            pln "\n"
        else
            exit 1
        fi
    fi

    pln "${C_P}Starting Shuttle CLI...\n"
    CLI=1
    while true; do
        init_prompt
        ans
    done
}

init_prompt() {
    if [[ "$NOANS" == 1 ]]; then
        NOANS=0
        pln "\e[1A\e[2K\e[1B"
    else
        pln "\n"
        pln "${C_B}   - $PWD -\n"
    fi
    pln "${C_P}   shuttle ${C_Y}>_ "
}

ans() {
    read -r ans

    if [[ -z "$ans" ]]; then
        NOANS=1
        return
    fi

    case "$ans" in

    exit)
        exit 0
        ;;

    clear)
        printf "\e[3J\e[2J\e[0H"
        return
        ;;

    cd*)
        cd ${ans:2}
        return
        ;;

    esac

    (source ./src/param_h.bash $ans)
}

main
