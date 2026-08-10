main() {
    local number=0
    declare -g -A filedead
    declare -g -A filteredindex
    local fileindex=0
    mapfile -t files < <(
        find "$dir" -type d -name .git -prune -o \
            -type f -name '*.bash' -print
    )

    # Progress bar
    buildStep=1
    buildStepd="Finding Files"
    buildProgress=0
    progbar_print

    for f in "${files[@]}"; do
        ((fileindex++))

        ### Ignore Logic

        # Ignore it's own build
        if [[ "$f" == "$dir/$name.bash" ]]; then
            continue
        fi

        plnv "$C_RS\n${C_Y}Found $f"

        filtered+=("$f")
        filteredindex["$f"]=$fileindex

        ((buildProgress++))
        plnva "\x1b7\e[$((buildProgress))A"
        buildDiff="Found $f"
        progbar_update
        plnva "\x1b8"
        ss

    done

    plnva "\x1b7\e[$((buildProgress))A"
    buildProgress=100
    buildDiff="Done"
    progbar_update
    plnva "\x1b8"

    # if a file isn't sourced, mark it "dead"
    if [[ "$RELEASE" == "true" ]]; then
        number=0
        ((buildStep++))
        plnva "\x1b7\e[${#filtered[@]}A"
        buildStepd="Validating Files"
        buildProgress=0
        buildDiff=""
        progbar_update
        plnva "\x1b8"

        plnva "\x1b7"
        for func in "${filtered[@]}"; do
            if ! rg "^[[:space:]]*(\([[:space:]]*)?source[[:space:]]+(\.)?${func#"$dir"}(.*)$" "$dir" >/dev/null 2>&1; then
                filedead["$func"]=1
                if [[ "$VERBOSE" == "true" && -t 1 ]]; then
                    pln "\x1b7"
                    pln "\e[${#filtered[@]}A"
                    pln "\e[${filteredindex["$func"]}B\e[1A"
                    pln "\e[G${C_ERR}DEAD  $func"
                    pln "\x1b8"
                fi
            fi

            plnva "\x1b7\e[${#filtered[@]}A"
            ((number++))
            buildProgress=$((number * 100 / ${#filtered[@]}))
            progbar_update
            plnva "\x1b8"
            ss
        done
    fi
}

main
