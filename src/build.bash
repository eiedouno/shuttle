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

    # Building message and information
    local buildinfomsg
    [[ -n $RELEASE || -n "$MINIMAL" ]] && buildinfomsg+=" (${RELEASE:+"Release"}${MINIMAL:+"Minimal"})"
    plnq "${C_B}Building $name$buildinfomsg...\n\n$C_RS"
    [[ -n "$MINIMAL" ]] && pln "${C_Y}WARNING: Minimal is experimental.\nIf your build fails to execute, consider removing this flag.\n\n"

    # Build
    source ./src/build/filter.bash
    if [[ "$RELEASE" == "true" ]]; then
        source ./src/build/release.bash || xx_failed
    fi
    source ./src/build/build.bash || xx_failed

    if [[ $RELEASE == "true" ]]; then
        deps=$(jq -r ".raw_deps[]?" "$dir/shuttle.json" 2>/dev/null)
        source ./lib/texts/rel.bash >>"$outfile"
        printf "__SHUTTLE_INIT \"\$@\"\n" >>"$outfile"
    fi

    printf "src_main \"\$@\"\n" >>"$outfile"
    chmod +x "$outfile"

    if [[ $QUIET != "true" && $VERBOSE != "true" ]]; then
        plna "\e[${#filtered[@]}A\e[1A\e[1G\e[0J\e[2A"
    fi

    # Completion status & DEAD functions
    plnq "\n\n"
    [[ (-n "${funcdead[*]}" || -n "${ifuncdead[*]}") && "$QUIET" != "true" ]] && pln "${C_ERR}The following functions were marked as DEAD and were not added to the build.\n" && for f in "${!funcdead[@]}"; do
        pln "${C_P}${C_BLD}file ${C_ERR}${f#"$dir"/} ${C_LHT}not sourced\n"
    done && for f in "${!ifuncdead[@]}"; do
        pln "${C_Y}function ${C_ERR}in ${funcs_from[$f]#"$dir"/} -> $f ${C_LHT}unused code\n"
    done
    [[ (-n "${funcdead[*]}" || -n "${ifuncdead[*]}") && "$QUIET" != "true" ]] && pln "\n"

    [[ -z "$shuttle_json_id" ]] || id_info=" ($shuttle_json_id)"
    plnq "${C_G}Successfully built $name$id_info. $C_LHT${#filtered[@]}${funcdead[*]:+"$C_ERR - ${#funcdead[@]}$C_RS$C_G$C_LHT"} files\n$C_RS"
}

main "$@"
