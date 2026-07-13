# For release builds, stripping unused code.
main() {
    local funcname
    local regp='^[[:space:]]*[^[:space:]]+\(\)[[:space:]]*\{'
    # Using assosiative arrays for speed checking ( if [[ "$funcs["$xxx"] == "1" ]]; )
    declare -g -A funcs
    declare -g -A ifuncdead
    declare -g -A funcs_from
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

    for f in "${!funcs[@]}"; do
        if ! rg -P "\b${f}\b(?![[:space:]]*\()" "$dir" | grep -v '^[[:space:]]*#' >/dev/null 2>&1; then
            ifuncdead["$f"]=1
        fi
    done
}

main
