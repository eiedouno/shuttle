if [[ "$1" == "" ]]; then
    dir="$PWD"
else
    dir="$(realpath $1)"
fi

name="$(basename $dir)"

main() {
    printf "\e[34mBuilding $name...\n\n\e[0m"
    mapfile -t files < <(find "$dir" -type f)

    for f in ${files[@]}; do

        # Ignore logic
	if head -n2 "$f" | grep -q "\.ignore"; then
	    echo "Skipping ignored file: ${f#$dir}"
	    continue
	fi

	if [[ "$f" == "$dir/$name.bash" ]]; then
	    continue
	fi

	local ext="${f##*/}"
	local ext="${ext#*.}"

	if [[ "$ext" == "bash" ]]; then
	    filtered+=("$f")
	fi

    done
    # printf '%b\n' "\e[35m${filtered[@]#$dir/}"
    source ./src/build/build.bash
    if [[ $? == "0" ]]; then
	printf "\n\n\e[35mSuccessfully built ${#filtered[@]} files.\n\e[0m"
    else
	printf "\n\n\e[31mAn unknown error occured.\n\e[0m"
    fi
}

main "$@"
