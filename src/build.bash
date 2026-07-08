if [[ "$1" == "" ]]; then
    dir="$PWD"
else
    dir="$(realpath "$1")"
fi

main() {
    get_acting_dir

    if [[ -f "$dir/shuttle.json" ]]; then
        source ./src/build/chk.bash
    fi

    local buildinfomsg
    [[ -n $PORTABLE || -n "$MINIMAL" ]] && buildinfomsg+=" (${PORTABLE:+"Portable"}${MINIMAL:+"Minimal"})"
    plnq "${C_B}Building $name$buildinfomsg...\n\n$C_RS"
    source ./src/build/filter.bash
    source ./src/build/build.bash || xx_failed

    if [[ $PORTABLE == "true" ]]; then
        deps=$(jq -r ".raw_deps[]" "$dir/shuttle.json")
        source ./lib/texts/port.bash >>"$outfile"
        printf "chk_deps\n" >>"$outfile"
    fi

    printf "src_main \"\$@\"\n" >>"$outfile"
    chmod +x "$outfile"

    if [[ $QUIET != "true" && $VERBOSE != "true" ]]; then
        pln "\e[${#filtered[@]}A\e[1A\e[1G\e[0J\e[2A"
    fi

    [[ -z "$shuttle_id" ]] || id_info=" ($shuttle_id)"
    plnq "\n\n${C_P}Successfully built $name$id_info. $C_LHT(${#filtered[@]} files)\n$C_RS"
}

main "$@"
