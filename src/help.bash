main() {
    if [[ -z "$2" ]]; then
	source ./lib/texts/usage.bash
	exit 0
    fi

    case $2 in

	build)
	    printf "\e[34mUsage: shuttle build [directory]\n\e[0m"
	    ;;

	docs)
	    source ./src/docs.bash
	    ;;

	new)
	    printf "\e[34mUsage: shuttle new <directory>\n\e[0m"
	    ;;

	init)
	    printf "\e[34mUsage: shuttle init\n\e[0m"
	    ;;

	run)
	    printf "\e[34mUsage: shuttle run [directory]\n\e[0m"
	    ;;

	bro)
	    printf "\e[32mRead the docs bro DX\n\e[0m"
	    ;;

	*)
	    printf "\e[31mCommand not found \'$2\'.\n\e[34mTry \'shuttle -h\'.\n\e[0m"
	    ;;
    esac
}

main "$@"
