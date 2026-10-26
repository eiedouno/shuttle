find_project_files() {
    local file
    declare -gA project_code
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue
        project_code["$file"]=1
        [[ "$SLOW" == "true" ]] && sleep 0.02
    done < <(
        rg --files -g "*.bash" "$working_directory"
    )

    filter_amount="${#project_code[@]}"
}

filter_project_files() {
    local file
    local fileindex=1
    declare -A filtered_files
    for file in "${!project_code[@]}"; do
        if [[ "$file" == "$working_directory/$PROJECT_NAME.bash" ]]; then
            continue
        fi

        filtered_files["$file"]=1

        plnv "${C_P}Found file: ${C_G}$file\n"
        build_diff="Found $file"
        build_progress=$((fileindex * 100 / filter_amount))
        progbar_update
        [[ "$SLOW" == "true" ]] && sleep 0.02

        ((fileindex++))
    done

    copy_aarray filtered_files PROJECT_FILES
}

# make_relative_project_files() {
#     local file
#     declare -gA RELATIVE_PROJECT_FILES
#
#     for file in "${!PROJECT_FILES[@]}"; do
#         file="${file//"$working_directory"/.}"
#         RELATIVE_PROJECT_FILES["$file"]=1
#         [[ "$SLOW" == "true" ]] && sleep 0.02
#     done
# }

# validate_project_files() {
#     local file
#     local current_function_name
#     local realpath
#
#     for file in "${!PROJECT_FILES[@]}"; do
#         current_function_name="$(convert_function_name "$file")"
#
#         if ! [[ "$file" == */lib/texts/* ]]; then
#             while IFS= read -r line; do
#                 if [[ "$line" =~ .*(\.\/.*\.bash).* ]]; then
#                     realpath="${BASH_REMATCH[1]/./"$working_directory"}"
#                     if [[ -f "$realpath" ]]; then
#                         RELATIVE_PROJECT_FILES["${BASH_REMATCH[1]}"]=2
#                         PROJECT_FILES["$realpath"]=2
#                     fi
#                 fi
#             done <"$file"
#         fi
#     done
# }

plnqa "\n"
build_step=1
build_step_desc="Finding Files"
build_progress=0
progbar_update

find_project_files
filter_project_files
# make_relative_project_files
# [[ "$RELEASE" == "true" ]] && validate_project_files
unset project_code
