# For release builds, stripping useless code from final.
main() {
    plna "\e[2K"
    pln "${C_B}Cleaning..."

    work
    while [[ "$worked" == "1" ]]; do
        work
    done

    mv -f "$outfile.working1" "$outfile.working" >/dev/null 2>&1 || xx_failed
    mv -f "$outfile.working" "$outfile" >/dev/null 2>&1 || xx_failed
}

# best function name, I know
work() {
    declare -g -A funcdellist
    declare -A depth=0
    declare -A ifuncname

    # track functions
    local funcdepth=0

    # workfile is $outfile on first run, but $outfile.working1 on other runs
    local workfile

    # for parse_line_depth
    local in_dquote=false
    local in_squote=false
    local escaped=false

    declare -A func_buffer=""
    declare -A func_is_empty=true

    # regex patterns
    local regp='^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*)[[:space:]]*\([[:space:]]*\)[[:space:]]*\{'
    local regp_empty='^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\([[:space:]]*\)[[:space:]]*\{[[:space:]]*\}[[:space:]]*$'

    if [[ "$worked" == 1 ]]; then
        workfile="$outfile.working1"
    else
        workfile="$outfile"
    fi

    : >"$outfile.working"

    while IFS= read -r line; do

        # if line is a function declaration
        if [[ "$line" =~ $regp ]]; then
            ((funcdepth++))

            # Function info
            func_buffer[$funcdepth]="$line"
            func_is_empty[$funcdepth]=true

            ifuncname[$funcdepth]="${line%%(*}"
            ifuncname[$funcdepth]="${ifuncname[$funcdepth]##* }"
            local rest="${line#*\{}"
            local prefix_len=$((${#line} - ${#rest} - 1))
            depth[$funcdepth]=1
            depth[$funcdepth]="$(parse_line_depth "${depth[$funcdepth]}" "${line:prefix_len+1}")"

            # Handle single-line functions ex: func() {}
            if [[ ${depth[$funcdepth]} -eq 0 ]]; then

                ((funcdepth--))

                # if function is a dead one-liner (or: if the programmer is stupid)
                if [[ "$line" =~ $regp_empty ]]; then
                    continue
                else
                    echo "$line" >>"$outfile.working"
                fi
            fi
        else

            # if inside a function
            if [[ "$funcdepth" -ge 1 ]]; then

                func_buffer[$funcdepth]+=$'\n'"$line"

                depth[$funcdepth]="$(parse_line_depth "${depth[$funcdepth]}" "$line")"

                # if the function closed
                if [[ ${depth[$funcdepth]} -eq 0 ]]; then

                    ((funcdepth--))

                    # if function isn't empty
                    if [[ "${func_is_empty[$((funcdepth + 1))]}" == "false" ]]; then

                        # if inside a function, add function to parent function's buffer, else just add it to the file
                        if [[ "$funcdepth" == 0 ]]; then

                            echo "${func_buffer[$((funcdepth + 1))]}" >>"$outfile.working"

                        else

                            func_buffer[$funcdepth]+=$'\n'"${func_buffer[$((funcdepth + 1))]}"

                        fi

                    else

                        funcdellist["${ifuncname[$((funcdepth + 1))]}"]=1

                    fi

                    # Reset tracking states for the next one
                    func_buffer[$((funcdepth + 1))]=""
                    func_is_empty[$funcdepth]=true

                else

                    # Not empty if the line contains code
                    if [[ "$line" =~ [^[:space:]] && ! "$line" =~ ^[[:space:]]*# ]]; then
                        func_is_empty[$funcdepth]=false
                    fi

                fi
            else
                # we are at the top level of the file, do nothing
                echo "$line" >>"$outfile.working"
            fi
        fi
    done <"$workfile"

    worked=0
    : >"$outfile.working1"
    local word
    local u
    local line_array=""

    # prune now-dead function calls
    while IFS= read -r line; do

        # trim leading whitespace
        aline="${line#"${line%%[![:space:]]*}"}"

        # make $line_array out of $aline
        mapfile -d ' ' -t line_array < <(printf '%s' "$aline")

        for word in "${line_array[@]}"; do

            # if word is in the func deletion list, swallow the line
            if [[ -n "$word" && ${funcdellist["$word"]} == 1 ]]; then
                u=1
                worked=1
            fi

        done

        [[ "$u" == 1 ]] && u=0 && continue

        echo "$line" >>"$outfile.working1"
    done <"$outfile.working"
}

main
