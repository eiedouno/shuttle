# For release builds, stripping unused code.
# # if a function isn't called, mark it dead
main() {
    local number=0
    plnva "\n"
    plnv "${C_B}Pre-evaluating cleanup..."
    plnva "\e[1A"

    plnva "\x1b7\e[$((${#filtered[@]}))A"
    ((buildStep++))
    buildDiff=""
    buildStepd="Finding functions"
    buildProgress=0
    progbar_update

    local funcname
    local regp='^[[:space:]]*[^[:space:]]+\(\)[[:space:]]*\{'

    # Using associative arrays for speed checking ( if [[ "$funcs["$xxx"] == "1" ]]; )
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
        ((number++))
        buildProgress=$((number * 100 / ${#filtered[@]}))
        progbar_update

        ss
    done

    ((buildStep++))
    buildDiff="Omitting useless functions"
    buildStepd="Verifying function calls"
    buildProgress=0
    progbar_update

    number=0
    # if the functions aren't called add them to $funcdead[]
    for f in "${!funcs[@]}"; do
        if ! rg -P "\b${f}\b(?![[:space:]]*\()" "$dir" | grep -v '^[[:space:]]*#' >/dev/null 2>&1; then
            funcdead["$f"]=1

        fi
        ((number++))
        buildProgress=$((number * 100 / ${#funcs[@]}))
        progbar_update

        ss
    done

    plnva "\x1b8"

}

main
