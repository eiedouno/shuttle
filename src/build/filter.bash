main() {
    printf "${C_B}Building $name...\n\n$C_RS"
    mapfile -t files < <(find "$dir" -type f)

    for f in ${files[@]}; do

        # Ignore logic
	if head -n2 "$f" | grep -q "\.ignore"; then
	    printf "\n${C_B}Skipping ignored file: ${f#$dir}"
	    continue
	fi

	# Ignore it's own build
	if [[ "$f" == "$dir/$name.bash" ]]; then
	    continue
	fi

	if [[ "$f" == $dir/.git* ]]; then
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
	printf "\n\n${C_P}Successfully built ${#filtered[@]} files.\n$C_RS"
    else
	printf "\n\n${C_ERR}An unknown error occured.\n$C_RS"
    fi
}

main "$@"
