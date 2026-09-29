if [[ "$1" == "" ]]; then
    workingDir="$PWD"
else
    workingDir="$(realpath "$1")"
fi

build() {
    get_working_dir

    if [[ -f "$workingDir/shuttle.json" ]]; then
        source ./src/build/chk.bash
    fi

    # Build start message and information
    [[ -n $RELEASE || -n "$MINIMAL" ]] && buildInfoMsg+=" (${RELEASE:+"Release"}${MINIMAL:+"Minimal"})"
    plnq "${C_B}Building $projectName$buildInfoMsg...\n\n$C_RS"
    [[ -n "$MINIMAL" ]] && pln "${C_Y}WARNING: Minimal is experimental.\nIf your build fails to execute, consider removing this flag.\n\n"

    if [[ "$RELEASE" == "true" ]]; then
        buildSteps=6
    else
        buildSteps=2
    fi

    plnqa "\e[?25l"

    # Filter build files
    source ./src/build/filter.bash

    # Build
    if [[ "$RELEASE" == "true" ]]; then
        source ./src/build/release/pre.bash
    fi

    source ./src/build/build.bash

    if [[ "$RELEASE" == "true" ]]; then
        source ./src/build/release/post.bash
    fi

    # Release additions
    if [[ $RELEASE == "true" ]]; then
        deps=$(jq -r ".raw_deps[]?" "$workingDir/shuttle.json" 2>/dev/null)
        source ./lib/texts/rel.bash >>"$outfile"
        printf "__SHUTTLE_INIT \"\$@\"\n" >>"$outfile"
    fi

    # Init call & exec flag
    printf "src_main \"\$@\"\n" >>"$outfile"
    chmod +x "$outfile"

    # UI clear
    plnva "\x1b7\e[$((${#filtered[@]} + 1))A\e[1G"
    if [[ "$VERBOSE" != "true" ]]; then
        plnqa "\e[0J"
    fi

    # Progress Bar
    plnqa "\e[2A\e[G"
    buildStep=$buildSteps
    buildDiff=""
    buildStepd="Finished"
    progbar_print

    plnva "\x1b8"

    # Completion status & DEAD functions
    plnqa "\n"
    plnva "\n"

    if [[ ("${funcdellist[src_main]}" == 1 || "${filedead["$workingDir/src/main.bash"]}" == 1) && "$QUIET" != "true" ]]; then
        pln "${C_Y}[WARNING]: Script may fail to execute! :: ${C_B}./src/main.bash was found to do nothing!\n"
    fi

    if [[ (-n "${filedead[*]}" || -n "${funcdead[*]}") && "$QUIET" != "true" ]]; then

        pln "${C_ERR}The following functions were marked as DEAD and were not added to the build.\n"

        # list all dead:

        # FILES
        for f in "${!filedead[@]}"; do
            pln "${C_P}${C_BLD}file ${C_ERR}${f#"$workingDir"/} $C_RS$C_ERR${C_LHT}not sourced\n"
        done

        # FUNCTIONS
        for f in "${!funcdead[@]}"; do
            pln "${C_Y}function ${C_ERR}in ${funcs_from[$f]#"$workingDir"/} -> $f ${C_LHT}unused code\n"
        done

    fi

    [[ (-n "${filedead[*]}" || -n "${funcdead[*]}") && "$QUIET" != "true" ]] && pln "\n"

    [[ -z "$shuttle_json_id" ]] || id_info=" ($shuttle_json_id)"
    plnq "${C_G}Successfully built $projectName$id_info. $C_LHT${#filtered[@]}${filedead[*]:+"$C_ERR - ${#filedead[@]}$C_RS$C_G$C_LHT"} files\n$C_RS"
}

progbar_print() {
    if [[ $buildProgress -gt 100 ]]; then
        buildProgress=100
    fi
    if [[ "$COLUMNS" -ge 80 ]]; then
        plnqa "\e[2K${C_B}($buildStep/$buildSteps) -> $buildStepd... \e[K${C_LHT}${buildDiff:+":: $buildDiff"}$C_RS\n\e[2K${C_B}[${C_Y}=\e[$((buildProgress * 30 / 100))b${C_B}>\e[34G] ${C_P}%$buildProgress\n"
    elif [[ "$COLUMNS" -ge 34 ]]; then
        plnqa "\e[2K${C_B}($buildStep/$buildSteps) -> $buildStepd...$C_RS\n\e[2K${C_B}[${C_Y}=\e[$((buildProgress * 30 / 100))b${C_B}>\e[34G] ${C_P}%$buildProgress\n"
    fi
    if [[ "$DEBUG" == "true" ]]; then
        plnqa "\e[2K"
    fi
}

progbar_setup() {
    plnqa "\e[2A\e[G"
}

progbar_update() {
    progbar_setup
    progbar_print
}

build "$@"
