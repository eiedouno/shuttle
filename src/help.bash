main() {
    if [[ -z "$2" ]]; then
	source ./lib/texts/usage.bash
	exit 0
    fi

    case $2 in

	build)
	    printf "${C_B}Usage: shuttle build [directory]\n$C_RS"
	    ;;

	docs)
	    source ./src/docs.bash
	    ;;

	new)
	    printf "${C_B}Usage: shuttle new <directory>\n$C_RS"
	    ;;

	init)
	    printf "${C_B}Usage: shuttle init\n$C_RS"
	    ;;

	run)
	    printf "${C_B}Usage: shuttle run [directory]\n$C_RS"
	    ;;

	help*)
	    printf "${C_G}Read the docs bro DX\n$C_RS"
	    ;;

	*)
	    printf "${C_ERR}Command not found \'$2\'.${C_RS}\n${C_B}Try \'shuttle -h\'.\n$C_RS"
	    ;;
    esac
}

main "$@"
