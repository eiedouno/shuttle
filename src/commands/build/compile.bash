create_outfile() {
    outfile="$working_directory/$PROJECT_NAME.bash"

    : >"$outfile"
    printf '%b' "#!/usr/bin/env ${PROJECT_SHELL:-"bash"}\n\n" >>"$outfile"
}

compile_project() {
    local line
    local file
    local fileindex=0
    local current_function_name
    local total_project_files="${#PROJECT_FILES[@]}"
    {
        for file in "${!PROJECT_FILES[@]}"; do
            current_function_name="$(convert_function_name "$file")"

            build_diff="Building $current_function_name"
            build_progress=$((fileindex * 100 / total_project_files))
            progbar_update >&2

            if [[ "$file" == */lib/texts/* ]]; then
                printf '%s() {\n' "$current_function_name"
                printf '%s\n' "$(<"$file")"
                printf "}\n\n"
            else
                printf '%s() {\n' "$current_function_name"
                clean_file "$file"
                printf "}\n\n"
            fi

            ((fileindex++))
            [[ "$SLOW" == "true" ]] && sleep 0.02
        done
    } >>"$outfile"
}

clean_file() {
    local -a lines
    local before_source quotes converted_function_name
    local line

    mapfile -t lines <"$1"

    for line in "${lines[@]}"; do
        if [[ "$line" =~ ^[[:space:]]*#.* ]]; then
            continue
        fi

        # Trim whitespace
        line="${line%"${line##*[![:space:]]}"}"

        if [[ "$line" == *source* ]]; then

            before_source="${line%%source*}"
            quotes="${before_source//[^\"]/}"
            quotes="${#quotes}"

            if ((quotes % 2 == 0)) && [[ "$line" =~ (^|[[:space:]])source[[:space:]]+([^[:space:]]*\.bash)?[[:space:]]? ]]; then
                clean_source_call "${BASH_REMATCH[@]}"
            fi
        fi

        if [[ "$line" =~ .*(\.\/[^[:space:]]*\.bash).* ]]; then
            converted_function_name=$(convert_function_name "${BASH_REMATCH[1]}")
            line="${line//"${BASH_REMATCH[1]}"/"$converted_function_name"}"
        fi

        printf '%s\n' "${line:+"    $line"}"
    done
}

clean_source_call() {
    local funcname

    if [[ "$VERBOSE" == "true" ]]; then
        local object
        local objectindex=1
        declare -A object_desc=(
            [1]="${C_G}Detected source call"
            [2]="${C_G}Detected whitespace"
            [3]="${C_G}Sourced file"
        )

        pln "\n\n${C_B}=== $file ===\n" >&2
        pln "${C_P}Detected line: \"${C_RS}$line${C_P}\"\n" >&2
        for object in "$@"; do
            pln "${object_desc[$objectindex]}: \"${object:-"${C_R}${C_LHT}null${C_RS}${C_G}"}\"\n" >&2
            ((objectindex++))
        done
    fi

    line="${line//source/}"

    if [[ "$3" =~ ^\.\/ ]]; then
        funcname="$(convert_function_name "$3")"
        plnv "${C_G}Converted function name: \"$funcname\"\n" >&2

        line="${line//"$3"/"$funcname"}"
    elif [[ "$3" =~ ^\"\.\/ ]]; then
        # if the source file is inside quotes
        plnv "${C_Y}Using the \"\" system! (quotes around the sourced file detected)\n" >&2

        funcname="${3//\"/}"
        plnv "${C_G}Converted function name: \"$funcname\"\n" >&2

        funcname="$(convert_function_name "$funcname")"
        line="${line//"$3\""/"\"$funcname\""}"
    elif [[ -n "$3" && -z "$2" ]]; then
        epln "Unresolveable source call in $file" "${VERBOSE:-"For more details, use verbose: 'shuttle build -v'"}" >&2
        plnv "\n${C_P}Converted line: \"${C_RS}$line${C_P}\"\n" >&2
        plnv "\n\n${C_Y}[Help]: If you intend to source a file outside of the project,\nuse absolute paths (don't use '.'), and change '${C_G}source${C_Y}' to '${C_G}.${C_Y}' on\nthe non-local source call\n\n[EXAMPLE]:\n\n    source ./$3\n" >&2
        exit 1
    fi

    plnv "\n${C_P}Converted line: \"${C_RS}$line${C_P}\"\n" >&2
}

((build_step++))
build_step_desc="Compiling"
build_progress=0

create_outfile
compile_project
