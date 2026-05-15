plnq "${C_B}Building $name...\n\n$C_RS"
mapfile -t files < <(
    find "$dir" -type d -name .git -prune -o \
    -type f -name '*.bash' -print
)

for f in "${files[@]}"; do

    ### Ignore Logic

    # Ignore it's own build
    if [[ "$f" == "$dir/$name.bash" ]]; then
        local stovrw=1
        local st="$dir/$name.bash"
        continue
    fi

    if head -n2 "$f" | grep -q '\.ignore'; then
	plnq "\n${C_B}Skipping ignored file: ${f#"$dir"}"
        continue
    fi

    plnq "$C_RS\n${C_Y}Found $f"
    filtered+=("$f")	

done

if [[ "$stovrw" == 1 ]]; then
    if [[ $FORCE != "true" ]]; then 
	pln "\n${C_ERR}'${st#"$dir"/}' will be overwritten, continue? (y/n): "
	read -rn1 ans
	if [[ "$ans" == "y" ]]; then	
	    plnq "\e[2K\e[1G\e[1A\e[0m"
	else
	    epln "Denied. Stopping..."
	    exit 1
	fi
    else
	plnq "\e[2K\e[1G\e[1A\e[0m"
    fi
fi
