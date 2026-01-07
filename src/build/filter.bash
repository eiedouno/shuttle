main() {
    printf "${C_B}Building $name...\n\n$C_RS"
    mapfile -t files < <(find "$dir" -type f)

    for f in ${files[@]}; do

        # Ignore logic
	local ext="${f##*/}"
	local ext="${ext#*.}"

	if [[ "$ext" != "bash" ]]; then
	    continue
	fi

	if [[ "$f" == $dir/.git* ]]; then
	    continue
	fi

	# Ignore it's own build
	if [[ "$f" == "$dir/$name.bash" ]]; then
	    printf "${C_ERR}'${f#$dir/}' will be overwritten, continue? (y/n): "
	    read -n1 ans
	    if [[ "$ans" == "y" ]]; then	
		printf "\e[2K\e[1G"
		continue
	    fi
	    printf "\n"
	    exit 1
	fi

	if head -n2 "$f" | grep -q '\.ignore'; then
	    printf "\n${C_B}Skipping ignored file: ${f#$dir}"
	    continue
	fi

	printf "$C_RS\n${C_Y}Found $f"
	filtered+=("$f")

    done
    # printf '%b\n' "\e[35m${filtered[@]#$dir/}"
}

main "$@"
