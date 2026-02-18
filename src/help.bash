main() {
    if [[ -z "$2" ]]; then
	source ./lib/texts/usage.bash
	exit 0
    fi

    case $2 in

	build)
	    pln "${C_B}Usage: shuttle build [directory]\n$C_RS"
	    ;;

	docs)
	    source ./src/docs.bash
	    ;;

	new)
	    pln "${C_B}Usage: shuttle new <directory>\n$C_RS"
	    ;;

	init)
	    pln "${C_B}Usage: shuttle init\n$C_RS"
	    ;;

	run)
	    pln "${C_B}Usage: shuttle run [directory]\n$C_RS"
	    ;;

	help*)
	    pln "${C_G}Read the docs bro DX\n$C_RS"
	    ;;

	*)
	    pln "${C_ERR}Command not found '$2'.${C_RS}\n${C_B}Try 'shuttle -h'.\n$C_RS"
	    ;;
    esac
}

main "$@"
