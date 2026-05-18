main() {
    if [ -d "$2" ]; then

	if [[ "$2" == "" ]]; then
	    dir="$PWD"
	else
	    dir="$(realpath "$2")"
	fi

	source ./src/build.bash "$dir"
	$outfile "${@:3}"

    elif [ -f "$2" ]; then
	$2
    elif [[ "$2" == "" ]]; then
	source ./src/build.bash "."
	$outfile "${@:3}"
    else
	epln "Unknown file or directory '$2'."
	exit 1
    fi
}

main "$@"
