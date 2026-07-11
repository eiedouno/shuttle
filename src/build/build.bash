main() {
    # add indentation if minimal isn't true
    [[ $MINIMAL == "true" ]] || MININD="    "
    MINNL="\n"
    [[ $MINIMAL == "true" ]] && MINNL=" "
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
                [[ $MINIMAL == "true" ]] || printf "\n\n\n"
            } >>"$outfile"

        else

            {
                printf "%s() {$MINNL" "$func_name"
                clean "$f"
                printf "}$MINNLL"
                [[ $MINIMAL == "true" ]] || printf "\n\n\n"
            } >>"$outfile"

        fi

        plnqa "\e[2K\e[1G"
        plnq "${C_G}Built $currentfunc\n${C_RS}"

    done
}

clean() {
    casef="0"
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

        if [[ "$clean_line" =~ ^[[:space:]]*(\([[:space:]]*)?source[[:space:]]+(.*)$ ]]; then
            indent="${BASH_REMATCH[1]}"
            read -r -a args <<<"source ${BASH_REMATCH[2]}"
            source_clean "${args[@]:1}"
        fi

        case "$clean_line" in
        esac
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

    clean_line="$MININD$indent$source_fn $allelse"
}

add() {
    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line"
    done <"$1"
}

main
