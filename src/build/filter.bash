main() {
    declare -g -A filedead
    declare -g -A filteredindex
    local fileindex=0
    mapfile -t files < <(
        find "$dir" -type d -name .git -prune -o \
            -type f -name '*.bash' -print
    )

    for f in "${files[@]}"; do
        ((fileindex++))

        ### Ignore Logic

        # Ignore it's own build
        if [[ "$f" == "$dir/$name.bash" ]]; then
            local stovrw=1
            local st="$dir/$name.bash"
            continue
        fi

        plnq "$C_RS\n${C_Y}Found $f"

        filtered+=("$f")
        filteredindex["$f"]=$fileindex

    done

    # if build file already found, confirm overwrite
    if [[ "$stovrw" == 1 ]]; then
        if [[ $FORCE != "true" ]]; then
            pln "\n${C_ERR}'${st#"$dir"/}' will be overwritten, continue? (y/n): "
            read -rn1 ans
            if [[ "$ans" == "y" ]]; then
                plnqa "\e[2K\e[1G\e[1A\e[0m"
            else
                if [[ "$VERBOSE" != "true" ]]; then
                    plnqa "\e[2K\e[1G\e[${#filtered[@]}A\e[0J\e[2A"
                fi
                epln "Denied. Stopping...(no confirmation)" "Use '-f' to force.\nCheck 'shuttle help build' for more information."
                exit 1
            fi
        else
            plnqa "\e[2K\e[1G\e[0m"
        fi
    fi

    # if a file isn't sourced, mark it "dead"
    if [[ "$RELEASE" == "true" ]]; then
        plna "\x1b7"
        for func in "${filtered[@]}"; do
            if ! rg "^[[:space:]]*(\([[:space:]]*)?source[[:space:]]+(\.)?${func#"$dir"}(.*)$" "$dir" >/dev/null 2>&1; then
                filedead["$func"]=1
                if [[ "$QUIET" != "true" && -t 1 ]]; then
                    pln "\e[${#filtered[@]}A"
                    pln "\e[${filteredindex["$func"]}B\e[1A"
                    pln "${C_ERR}DEAD  $func\n"
                fi
            fi
        done
        plna "\x1b8"
    fi
}

main
