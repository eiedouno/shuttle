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
	source ./src/build/build.bash || xx_failed
	
	if [[ $PORTABLE == "true" ]]; then
	    deps=$(jq -r ".raw_deps[]" "$dir/shuttle.json")
	    source ./lib/texts/port.bash >> "$outfile"
	    printf "chk_deps\n" >> "$outfile"
	fi

	printf "src_main \"\$@\"\n" >> "$outfile"
	chmod +x "$outfile"
	plnq "\n\n${C_P}Successfully built $name ($shuttle_id). $C_LHT(${#filtered[@]} files)\n$C_RS"

    else
	if [[ "$dir" == "/" ]]; then
	    epln "Unable to find shuttle project in directory." "Make sure you're inside the root of your project."
	    exit 1
	fi
	cd .. || xx_failed
	dir="$(realpath "$(pwd)")"
	main "$@"
    fi
}

main "$@"
