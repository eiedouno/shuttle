main() {
    if [[ -z "$2" ]]; then
        source ./lib/texts/usage.bash
        exit 0
    fi

    case $2 in

    add)
        pln "${C_B}\e[1m\e[4mUsage:\e[0m shuttle add <project>\n"
        ;;

    build)
        source ./lib/texts/help/build.bash
        ;;

    docs)
        source ./src/docs.bash
        ;;

    new)
        pln "${C_B}Usage: shuttle new <directory>\n$C_RS"
        ;;

    init)
        pln "${C_B}Usage: shuttle init\n(same as 'shuttle new .')\n$C_RS"
        ;;

    run)
        pln "${C_B}Usage: shuttle run [directory]\n$C_RS"
        ;;

    install)
        source ./lib/texts/help/install.bash
        ;;

    uninstall)
        source ./lib/texts/help/uninstall.bash
        ;;

    ssl*)
        source ./lib/texts/help/ssl.bash
        ;;

    help*)
        pln "${C_G}Read the docs bro DX\n$C_RS"
        ;;

    all)
        source ./lib/texts/usage-all.bash
        ;;

    *)
        epln "Command not found '$2'." "Try 'shuttle -h'."
        ;;
    esac
}

main "$@"
