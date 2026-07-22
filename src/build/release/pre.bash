# For release builds, stripping unused code.
# # if a function isn't called, mark it dead
main() {
    plna "\n"
    pln "${C_B}Pre-evaluating cleanup..."
    plna "\e[1A"

    local funcname
    local regp='^[[:space:]]*[^[:space:]]+\(\)[[:space:]]*\{'

    # Using assosiative arrays for speed checking ( if [[ "$funcs["$xxx"] == "1" ]]; )
    declare -g -A funcs
    declare -g -A funcdead
    declare -g -A funcs_from

    # find functions
    for f in "${filtered[@]}"; do

        while IFS= read -r line || [ -n "$line" ]; do

            if [[ "$line" =~ $regp ]]; then

                funcname="${line%%(*}"
                funcname="${funcname##* }"
                funcs["$funcname"]=1
                funcs_from["$funcname"]="$f"

            fi
        done <"$f"
    done

    # if the functions aren't called add them to $funcdead[]
    for f in "${!funcs[@]}"; do
        if ! rg -P "\b${f}\b(?![[:space:]]*\()" "$dir" | grep -v '^[[:space:]]*#' >/dev/null 2>&1; then
            funcdead["$f"]=1
        fi
    done
}

main
