main() {
    outfile="$dir/$name.bash"

    : > "$outfile"
    for f in ${filtered[@]}; do
	func_name="${f#$dir/}"
	func_name="${func_name%.bash}"
	func_name="${func_name//[\/.]/_}"
	if [[ "$f" == *lib/texts/* ]]; then
	    {
		printf "%s() {\n" "$func_name"
		add "$f"
		printf "}\n\n\n"
	    } >> "$outfile"
	    continue
	else
	    {
		printf "%s() {\n" "$func_name"
		clean "$f"
		printf "}\n\n\n"
	    } >> "$outfile"
	fi
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
    local allelse="${@:3}"
    local source_fn="${2#*./}"
    local source_fn="${source_fn%.bash*}"
    local source_fn="${source_fn//[\/.]/_}"
    line="    ${indent}$source_fn $allelse"
}

add() {
    while IFS= read -r line || [ -n "$line" ]; do
	echo "    $line"
    done < "$1"
}

main
