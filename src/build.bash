if [[ "$1" == "" ]]; then
    dir="$PWD"
else
    dir="$(realpath "$1")"
fi

main() {
    name="$(basename "$dir")"

    if [[ -f "$dir/src/main.bash" ]]; then

	if [[ -f "$dir/shuttle.json" ]]; then
	    source ./src/build/chk.bash
	fi
	source ./src/build/filter.bash
	source ./src/build/build.bash

	if [[ $? == "0" ]]; then
	    pln "\n\n${C_P}Successfully built $name ($shuttle_id). $C_LHT(${#filtered[@]} files)\n$C_RS"
	    else
		pln "\n\n${C_ERR}An unknown error occured.\n$C_RS"
		exit 1
	fi

    else
	if [[ "$dir" == "/" ]]; then
	    pln "${C_ERR}Unable to find shuttle project in directory.$C_RS\n${C_B}Make sure you're inside the root of your project.\n$C_RS"
	    exit 1
	fi
	cd .. || xx_failed
	dir="$(realpath "$(pwd)")"
	main "$@"
    fi
}

main "$@"
