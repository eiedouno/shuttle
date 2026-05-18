f1() {
    [[ -z "$@" ]] && epln "Command not specified." "Try 'shuttle -h'." && exit 1

    declare -A help=(
	[type]="bool"
	[alias]="h"
    )

    declare -A version=(
	[type]="bool"
	[alias]="v"
    )

    declare -A update=(
	[type]="bool"
	[alias]="u"
    )

    declare -A ud_lib=(
	[name]="update-library"
	[type]="bool"
	[alias]="y"
    )

    declare -A clearcache=(
	[name]="clear-cache"
	[type]="bool"
    )

    declare -A force=(
	[type]="bool"
	[alias]="f"
    )

    declare -A quiet=(
	[type]="bool"
	[alias]="q"
    )

    args=(help version update ud_lib clearcache force quiet)
    PARAM_AUTO_EXIT="false"
    PARAM_ERROR_MSG="false"

    declare -a pargs=("$@")
    source ./lib/param/handle.bash "$@"



    if [[ "${help[value]}" == "true" ]]; then
	source ./lib/texts/usage.bash
	exit
    fi


    if [[ "${version[value]}" == "true" ]]; then
	source ./lib/texts/version.bash
	exit
    fi
    

    if [[ "${update[value]}" == "true" ]]; then
	source ./src/update.bash
	exit
    fi


    if [[ "${ud_lib[value]}" == "true" ]]; then
	source ./src/update_l.bash
	exit
    fi


    if [[ "${clearcache[value]}" == "true" ]]; then
	source ./src/reset.bash
	exit
    fi


    [[ "${force[value]}" == "true" ]] && FORCE="true"
    [[ "${quiet[value]}" == "true" ]] && QUIET="true"


    [[ -z "${param_extra[*]}" ]] && epln "Command not specified." "Try 'shuttle -h'." && exit 1
    f2 "${param_extra[@]}"
}



f2() {
    case "$1" in

	help)
	    source ./src/help.bash "$@"
	    ;;

	b|build)
	    fc_build "${2:+"${@:2}"}"
	    source ./src/build.bash "${g1}"
	    ;;

	add)
	    source ./src/add.bash "${2:+"${@:2}"}"
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
	    fc_build "${2:+"${@:2}"}"
	    source ./src/install.bash "${g1[value]}"
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



fc_build() {
    declare -A minimal=(
	[type]="bool"
	[alias]="m"
    )

    declare -A portable=(
	[type]="bool"
	[alias]="p"
    )

    declare -A small=(
	[type]="bool"
    )

    args=(minimal portable small)
    PARAM_ERROR_MSG="true"
    source ./lib/param/handle.bash "$@"
    g1=("${param_extra[@]}")

    [[ "${minimal[value]}" == "true" ]] && MINIMAL="true"
    [[ "${portable[value]}" == "true" ]] && PORTABLE="true"
}



f1 "$@"
