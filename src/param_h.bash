param_h1() {
    case "$1" in

	-h|--help)
	    source ./lib/texts/usage.bash
	    ;;

	-v|--version)
	    source ./lib/texts/version.bash
	    ;;

	-u|--update)
	    source ./src/update.bash
	    ;;
	*)
	    param_h2 "$@"
	    ;;
    esac
}

param_h2() {
    case "$1" in

	help)
	    source ./src/help.bash "$@"
	    ;;

	b|build)
	    source ./src/build.bash "$2"
	    ;;

	docs)
	    source ./src/docs.bash
	    ;;

	new)
	    source ./src/new.bash "$2"
	    ;;

	init)
	    source ./src/init.bash
	    ;;

	r|run)
	    source ./src/run.bash "$@"
	    ;;

	install)
	    source ./src/install.bash "$2"
	    ;;

	uninstall)
	    source ./src/uninstall.bash "$2"
	    ;;

	*)
	    printf "\e[31mCommand not known \'$1\'.\n\e[34mTry \'shuttle -h\'\n\e[0m"
	    exit 1
    esac
}

if [[ "$#" == "0" ]]; then
    printf "\e[31mCommand not specified.\n\e[34mTry \'shuttle -h\'.\n\e[0m"
    exit 1
fi

param_h1 "$@"
