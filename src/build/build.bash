main() {
    outfile="$dir/$name.bash"
    printf "\033[$((${#filtered[@]} - 1))A"
    : > "$outfile"
    printf "#!/usr/bin/env bash\n" >> "$outfile"


    for f in ${filtered[@]}; do
	local currentfunc="$f"
	printf "\e[2K\e[1G${C_B}Building $currentfunc ..."
	func_name="${f#$dir/}"
	func_name="${func_name%.bash}"
	func_name="${func_name//[\/.]/_}"
	if [[ "$f" == *lib/texts/* ]]; then
	    {
		printf "%s() {\n" "$func_name"
		add "$f"
		printf "}\n"
	    } >> "$outfile"
	else
	    {
		printf "%s() {\n" "$func_name"
		clean "$f"
		printf "}\n"
	    } >> "$outfile"
	fi
	printf "\e[2K\e[1G"
	printf "${C_G}Built $currentfunc\n${C_RS}"
    done

    printf "src_main \"\$@\"\n" >> "$outfile"
    chmod +x "$outfile"
}

clean() {
    while IFS= read -r line || [ -n "$line" ]; do

	local clean_line="${line%%#*}"

	if [ -z "$clean_line" ]; then
	    continue
	fi

	if [[ "$clean_line" =~ ^[[:space:]]*source[[:space:]]+.*$ ]]; then
	    indent="${BASH_REMATCH[1]}"
	    source_clean $line
	fi
	    
	echo "    $line"

    done < "$1"
}

source_clean() {
    local yes=false
    local yozo
    
    for f in "${filtered[@]}"; do
	yozo="${f#$dir/}"
	if [[ $@ == *"$yozo"* ]]; then
	    yes=true
	fi
    done

    if ! $yes; then
	return
    fi

    local allelse="${@:3}"
    local source_fn="${2#*./}"
    local source_fn="${source_fn%.bash*}"
    local source_fn="${source_fn//[\/.]/_}"
    line="    ${indent}$source_fn $allelse"
}

add() {
    while IFS= read -r line || [ -n "$line" ]; do
	echo "$line"
    done < "$1"
}

main
