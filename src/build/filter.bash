main() {
    pln "${C_B}Building $name...\n\n$C_RS"
    mapfile -t files < <(find "$dir" -type f)

    for f in "${files[@]}"; do

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
	    local stovrw=1
	    local st="$dir/$name.bash"
	    continue
	fi

	if head -n2 "$f" | grep -q '\.ignore'; then
	    pln "\n${C_B}Skipping ignored file: ${f#"$dir"}"
	    continue
	fi

	pln "$C_RS\n${C_Y}Found $f"
	filtered+=("$f")	

    done
    # pln '%b\n' "\e[35m${filtered[@]#$dir/}"
    if [[ "$stovrw" == 1 ]]; then 
	pln "\n${C_ERR}'${f#"$st"/}' will be overwritten, continue? (y/n): "
	read -rn1 ans
	if [[ "$ans" == "y" ]]; then	
	    pln "\e[2K\e[1G\e[1A\e[0m"
	else
	    pln "\n${C_ERR}Denied. Stopping...\n$C_RS"
	    pln "\n"
	    exit 1
	fi
    fi
}

main "$@"
