main() {
    # add indentation if minimal isn't true
    [[ $MINIMAL == "true" ]] || MININD='    '
    MINNL="\n"
    [[ $MINIMAL == "true" ]] && MINNL=" "
    MINNLL="\n\n\n"
    [[ $MINIMAL == "true" ]] && MINNLL="\n"

    outfile="$dir/$name.bash"

    plnqa "\e[$((${#filtered[@]} - 1))A"

    # init outfile
    : >"$outfile"
    printf "#!/usr/bin/env bash\n" >>"$outfile"
    [[ $MINIMAL == "true" ]] || printf "\n" >>"$outfile"

    for f in "${filtered[@]}"; do
        if [[ "${funcdead["$f"]}" == "1" ]]; then
            plnq "\n"
            continue
        fi
        local currentfunc="$f"
        plnqa "\e[2K\e[1G${C_B}Building $currentfunc ..."

        func_name="${f#"$dir"/}"
        func_name="${func_name%.bash}"
        func_name="${func_name//[\/.]/_}"

        if [[ "$f" == *lib/texts/* ]]; then

            {
                printf "%s() {$MINNL" "$func_name"
                add "$f"
                printf "}$MINNLL"
            } >>"$outfile"

        else

            {
                printf "%s() {$MINNL" "$func_name"
                clean "$f"
                printf "}$MINNLL"
            } >>"$outfile"

        fi

        plnqa "\e[2K\e[1G"
        plnq "${C_G}Built $currentfunc\n${C_RS}"

    done
}

clean() {
    casef="0"
    depth="0"
    local ifuncname
    local in_dquote=false
    local in_squote=false
    local escaped=false

    while IFS= read -r line || [ -n "$line" ]; do

        if [[ "$line" =~ ^[[:space:]]*#.* && "$MINIMAL" == "true" ]]; then
            continue
        else
            clean_line="$line"
        fi

        local regp='^[[:space:]]*[^[:space:]]+\(\)[[:space:]]*\{'
        if [[ "$RELEASE" == "true" && "$line" =~ $regp ]]; then
            ifuncname="${line%%(*}"
            ifuncname="${ifuncname##* }"
            if [[ "${ifuncdead[$ifuncname]}" == "1" ]]; then
                echo "${MININD}true"
                local rest="${line#*\{}"
                local prefix_len=$((${#line} - ${#rest} - 1))
                depth=1
                parse_line_depth "${line:prefix_len+1}"
                continue
            fi
        fi

        # Release only
        if [[ "$depth" -ge "1" ]]; then
            parse_line_depth "$line"
            continue
        fi

        # Trim trailing whitespace (and leading, if minimal)
        [[ $MINIMAL == "true" ]] && clean_line="${clean_line#"${clean_line%%[![:space:]]*}"}"
        clean_line="${clean_line%"${clean_line##*[![:space:]]}"}"

        if [[ -z "$clean_line" && "$MINIMAL" == "true" ]]; then
            continue
        fi

        if [[ "$clean_line" =~ ^[[:space:]]*(\([[:space:]]*)?source[[:space:]]+(.*)$ ]]; then
            indent="${BASH_REMATCH[1]}"
            read -r -a args <<<"source ${BASH_REMATCH[2]}"
            source_clean "${args[@]:1}"
        fi

        if [[ -n "$clean_line" ]]; then
            if [[ "$MINIMAL" == "true" ]]; then
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
                echo "$MININD$clean_line"
            fi
        fi

    done <"$1"
}

source_clean() {
    local yes=false
    local yozo

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

add() {
    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line"
    done <"$1"
}

parse_line_depth() {
    local line="$1"
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
                # Comments only start at word boundaries (preceded by whitespace/delimiters)
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
                ((depth++))
            elif [[ "$char" == "}" ]]; then
                ((depth--))
            fi
        fi
    done
    escaped=false
}

main
