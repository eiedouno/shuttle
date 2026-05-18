main() {
    # add indentation if minimal isn't true
    [[ $MINIMAL == "true" ]] || MININD="    "

    outfile="$dir/$name.bash"

    plnq "\e[$((${#filtered[@]} - 1))A"

    # init outfile
    : > "$outfile"
    printf "#!/usr/bin/env bash\n" >> "$outfile"
    [[ $MINIMAL == "true" ]] || printf "\n" >> "$outfile"



    for f in "${filtered[@]}"; do
	local currentfunc="$f"
	plnq "\e[2K\e[1G${C_B}Building $currentfunc ..."

	func_name="${f#"$dir"/}"
	func_name="${func_name%.bash}"
	func_name="${func_name//[\/.]/_}"

	if [[ "$f" == *lib/texts/* ]]; then

	    {
		printf "%s() {\n" "$func_name"
		add "$f"
		printf "}\n"
		[[ $MINIMAL == "true" ]] || printf "\n\n"
	    } >> "$outfile"

	else

	    {
		printf "%s() {\n" "$func_name"
		clean "$f"
		printf "}\n"
		[[ $MINIMAL == "true" ]] || printf "\n\n"
	    } >> "$outfile"

	fi

	plnq "\e[2K\e[1G"
	plnq "${C_G}Built $currentfunc\n${C_RS}"

    done
}



clean() {
    while IFS= read -r line || [ -n "$line" ]; do


	if [[ "$line" =~ ^[[:space:]]*#.* && "$MINIMAL" == "true" ]]; then
	    # no comment-only lines
	    clean_line=""
	else
	    clean_line="$line"
	fi


	# Trim trailing whitespace (and leading, if minimal)
	[[ $MINIMAL == "true" ]] && clean_line="${clean_line#"${clean_line%%[![:space:]]*}"}"
	clean_line="${clean_line%"${clean_line##*[![:space:]]}"}"


	if [[ -z "$clean_line" && "$MINIMAL" == "true" ]]; then
	    continue
	fi


	if [[ "$clean_line" =~ ^[[:space:]]*source[[:space:]]+.*$ ]]; then
	    indent="${BASH_REMATCH[1]}    "
	    read -r -a args <<< "$clean_line"
	    source_clean "${args[@]:1}"
	fi



	# if clean_line is nothing, print nothing, else, use clean_line with the conditional indentation
	echo "${clean_line:+$MININD$clean_line}"

    done < "$1"
}

source_clean() {
    local yes=false
    local yozo
    
    for f in "${filtered[@]}"; do
	yozo="${f#"$dir"/}"
	if [[ "$@" == *"$yozo"* ]]; then
	    yes=true
	fi
    done

    [[ ! $yes ]] && return

    local allelse="${@:2}"
    local source_fn="${1#*./}"
    local source_fn="${source_fn%.bash*}"
    local source_fn="${source_fn//[\/.]/_}"

    clean_line="$MININD$indent$source_fn $allelse"
}

add() {
    while IFS= read -r line || [ -n "$line" ]; do
	echo "$line"
    done < "$1"
}

main
