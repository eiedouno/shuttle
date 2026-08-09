main() {
    local number=0
    # progress bar
    if [[ "$RELEASE" == "true" ]]; then
        buildStep=4
    else
        buildStep=2
    fi
    buildStepd="Compiling"
    buildProgress="0"
    buildDiff=""
    plnva "\x1b7\e[$((${#filtered[@]}))A"
    progbar_update
    plnva "\x1b8"

    # add indentation if minimal isn't true ( I do things the hard way then leave them because they work )
    [[ $MINIMAL == "true" ]] || MININD='    '
    [[ $MINIMAL == "true" ]] && MINNL=" " || MINNL="\n"
    [[ $MINIMAL == "true" ]] && MINNLL="\n" || MINNLL="\n\n\n"

    outfile="$dir/$name.bash"

    plnva "\e[$((${#filtered[@]} - 1))A"

    # init outfile
    : >"$outfile"
    printf "#!/usr/bin/env bash\n" >>"$outfile"
    [[ $MINIMAL == "true" ]] || printf "\n" >>"$outfile"

    # for each .bash file found:
    for f in "${filtered[@]}"; do

        # If nothing links to it, skip it
        if [[ "${filedead["$f"]}" == "1" ]]; then
            plnv "\n"
            continue
        fi

        local currentfunc="$f"
        plnva "\e[2K\e[1G${C_B}Building $currentfunc ..."

        func_name="${f#"$dir"/}"
        func_name="${func_name%.bash}"
        func_name="${func_name//[\/.]/_}"

        if [[ "$f" == *lib/texts/* ]]; then

            # for multiline-text
            {
                printf "%s() {$MINNL" "$func_name"
                add "$f"
                printf "}$MINNLL"
            } >>"$outfile"

        else

            # all-else
            {
                printf "%s() {$MINNL" "$func_name"
                clean "$f"
                printf "}$MINNLL"
            } >>"$outfile"

        fi

        ((number++))
        plnva "\e[2K\e[1G"
        plnv "${C_G}Built $currentfunc${C_RS}"

        # progress bar
        plnva "\x1b7\e[$((${filteredindex["$f"]} - 1))A"
        buildDiff="Built $currentfunc"
        buildProgress=$((number * 100 / ${#filtered[@]}))
        progbar_update
        plnva "\x1b8\n"

    done
}

clean() {
    casef="0"
    depth="0"
    local funcname
    local in_dquote=false
    local in_squote=false
    local escaped=false
    local regp='^[[:space:]]*[^[:space:]]+\(\)[[:space:]]*\{'

    # for each line, do
    while IFS= read -r line || [ -n "$line" ]; do

        # strip comment-lines if release or minimal is set
        if [[ ("$RELEASE" == "true" || "$MINIMAL" == "true") && "$line" =~ ^[[:space:]]*#.* ]]; then
            continue
        else
            clean_line="$line"
        fi

        # detect function declarations (for release builds)
        if [[ "$RELEASE" == "true" && "$line" =~ $regp ]]; then

            funcname="${line%%(*}"
            funcname="${funcname##* }"

            if [[ "${funcdead[$funcname]}" == "1" ]]; then

                # rest == everything after the function declaration
                local rest="${line#*\{}"
                local prefix_len=$((${#line} - ${#rest} - 1))

                # parse the rest of the function declaration line
                depth=1
                depth="$(parse_line_depth "$depth" "${line:prefix_len+1}")"

                continue

            fi
        fi

        # Release only: look for the end of the found function
        if [[ "$depth" -ge "1" ]]; then
            depth="$(parse_line_depth "$depth" "$line")"
            continue
        fi

        # Trim trailing whitespace (and leading, if minimal)
        [[ $MINIMAL == "true" ]] && clean_line="${clean_line#"${clean_line%%[![:space:]]*}"}"
        clean_line="${clean_line%"${clean_line##*[![:space:]]}"}"

        # if the whitespace made it empty or it's just an empty line in general, skip
        if [[ -z "$clean_line" && "$MINIMAL" == "true" ]]; then
            continue
        fi

        # if the line is a source call
        if [[ "$clean_line" =~ ^[[:space:]]*(\([[:space:]]*)?source[[:space:]]+(.*)$ ]]; then
            indent="${BASH_REMATCH[1]}"
            read -r -a args <<<"source ${BASH_REMATCH[2]}"
            source_clean "${args[@]:1}"
        fi

        # if the clean line has any value
        if [[ -n "$clean_line" ]]; then

            # if minimal is true, strip newlines
            if [[ "$MINIMAL" == "true" ]]; then
                # bro wrote a whole bash syntax interpreter in bash DX
                if [[ "$casef" -ge 1 ]]; then
                    case "$clean_line" in
                    *esac)
                        ((casef--))
                        printf "%s; " "$clean_line"
                        ;;
                    *"\\")
                        clean_line="${clean_line% \\*}"
                        printf "%s " "$clean_line"
                        ;;
                    *then | *else | *elif | *do | *\{ | *\& | *\| | *\;\; | *\<\( | *\\\)\))
                        printf "%s " "$clean_line"
                        ;;
                    *\)\))
                        printf "%s; " "$clean_line"
                        ;;
                    *\))
                        printf "%s " "$clean_line"
                        ;;
                    *"case "*)
                        ((casef++))
                        printf "%s " "$clean_line"
                        ;;
                    *)
                        printf "%s; " "$clean_line"
                        ;;
                    esac
                else
                    case "$clean_line" in
                    *"\\")
                        clean_line="${clean_line% \\*}"
                        printf "%s " "$clean_line"
                        ;;
                    *then | *else | *elif | *do | *\{ | *\& | *\| | *\;\; | *\<\( | *\\\)\))
                        printf "%s " "$clean_line"
                        ;;
                    *\)\))
                        printf "%s; " "$clean_line"
                        ;;
                    *"case "*)
                        ((casef++))
                        printf "%s " "$clean_line"
                        ;;
                    *)
                        printf "%s; " "$clean_line"
                        ;;
                    esac
                fi
            else
                # for normal people who don't use minimal, just write the line like a good boy
                echo "$MININD$clean_line"
            fi
        fi

    done <"$1"
}

# convert source calls to the new function names
source_clean() {
    local yes=false
    local f
    local yozo

    # do the slow for-loop test bc I didn't know about `declare -A` back I wrote this part
    for f in "${filtered[@]}"; do
        yozo="${f#"$dir"/}"
        if [[ "$*" == *"$yozo"* ]]; then
            yes=true
        fi
    done

    [[ ! $yes ]] && return

    local allelse="${@:2}"
    local source_fn="${1#*./}"
    local source_fn="${source_fn%.bash*}"
    local source_fn="${source_fn//[\/.]/_}"

    clean_line="$MININD$indent$source_fn${allelse:+ $allelse}"
}

# clean() without the logic
add() {
    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line"
    done <"$1"
}

# the stupidist thing i've ever wrote (& it's messy af)
parse_line_depth() {
    local ldepth="$1"
    local line="$2"
    local len="${#line}"
    local char prev

    for ((i = 0; i < len; i++)); do
        char="${line:i:1}"
        if $escaped; then
            escaped=false
            continue
        fi
        if [[ "$char" == "\\" ]]; then
            if ! $in_squote; then
                escaped=true
            fi
            continue
        fi

        # String states
        if $in_dquote; then
            if [[ "$char" == '"' ]]; then
                in_dquote=false
            fi
        elif $in_squote; then
            if [[ "$char" == "'" ]]; then
                in_squote=false
            fi
        else
            # Not in quotes, check comments and count braces
            if [[ "$char" == '"' ]]; then
                in_dquote=true
            elif [[ "$char" == "'" ]]; then
                in_squote=true
            elif [[ "$char" == "#" ]]; then
                # Comments only start at word boundaries (preceded by whitespace) (hopefully)
                if ((i == 0)); then
                    break
                else
                    prev="${line:i-1:1}"
                    local regp='[[:space:];&|\(\)]'
                    if [[ "$prev" =~ $regp ]]; then
                        break
                    fi
                fi
            elif [[ "$char" == "{" ]]; then
                ((ldepth++))
            elif [[ "$char" == "}" ]]; then
                ((ldepth--))
            fi
        fi
    done
    escaped=false
    printf '%s' "$ldepth"
}

main
