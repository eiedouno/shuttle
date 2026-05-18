paramc_build() {
    param_h() {
	for f in $@; do
	    if [[ "$f" == --* ]]; then
		con="${f#--}"
		param_h2
	    elif [[ "$f" == -* ]]; then
		con="${f#-}"
		param_h1
	    else
		g1="$f"
	    fi

	done
    }

    param_h1() {
	while IFS= read -r -n1 char; do
	    [[ -z "$char" ]] && continue

	    case $char in
		p)
		    PORTABLE=true
		    ;;
		q)
		    QUIET=true
		    ;;
		m)
		    MINIMAL=true
		    ;;
		f)
		    FORCE=true
		    ;;
		*)
		    epln "Unknown option '-$char'" "Try 'shuttle help <command>'" && exit 1
		    ;;
	    esac
	done <<< "$con"
    }

    param_h2() {
	case $con in
	    portable)
		PORTABLE=true
		;;
	    quiet)
		QUIET=true
		;;
	    minimal)
		MINIMAL=true
		;;
	    small)
		SMALL=true
		;;
	    force)
		FORCE=true
		;;
	    *)
		epln "Unknown option '--$con'" "Try 'shuttle help <command>'" && exit 1
		;;
	esac
    }
    param_h "$@"
}

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

	-y|--update-library)
	    source ./src/update_l.bash
	    (( $# >= "2" )) && param_h2 "${@:2}"
	    ;;

	--clear-cache)
	    source ./src/reset.bash
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
	    paramc_build "${2:+"${@:2}"}"
	    source ./src/build.bash "$g1"
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
	    paramc_build "${2:+"${@:2}"}"
	    source ./src/install.bash "$g1"
	    ;;

	uninstall)
	    source ./src/uninstall.bash "$2"
	    ;;

	ssl)
	    source ./src/ssl.bash "${2:+"${@:2}"}"
	    ;;

	*)
	    epln "Command not known '$1'." "Try 'shuttle -h'"
	    exit 1
    esac
}

if [[ "$#" == "0" ]]; then
    epln "Command not specified." "Try 'shuttle -h'."
    exit 1
fi

param_h1 "$@"
