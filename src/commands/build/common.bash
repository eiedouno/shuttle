convert_function_name() {
    local function="$1"
    local name="${function#"$working_directory/"}"
    name="${name#"./"}"
    name="${name%.bash}"
    name="${name//[\/.]/_}"
    printf '%s' "$name"
}

get_term_size() {
    if [[ -t 1 ]]; then
        local reply
        printf '\e7\e[9999;9999H\e[6n\e8' >/dev/tty
        if IFS='[;' read -r -t 0.1 -d R -a reply _ </dev/tty; then
            LINES=${reply[1]}
            COLS=${reply[2]}
        else
            LINES=24
            COLS=80
        fi
        plna "\e[2K\e[1G"
    fi
}

progbar_update() {
    if [[ "$QUIET" != "true" && -t 1 && "$VERBOSE" != "true" ]]; then
        local buffer

        if [[ $build_progress -gt 100 ]]; then
            build_progress=100
        fi

        if [[ "$COLS" -ge 80 ]]; then
            buffer+="\e[2K${C_B}($build_step/$build_steps) --> $build_step_desc ${C_LHT}${build_diff:+":: $build_diff"}$C_RS\n"
            buffer+="\e[2K${C_B} ${C_Y}·\e[$((build_progress * 30 / 100))b${C_B}>\e[34G${C_G}· ${C_P}%$build_progress\n"
            pln "$buffer\e[2A"
        elif [[ "$COLS" -ge 40 ]]; then
            buffer+="\e[2K${C_B}($build_step/$build_steps) --> $build_step_desc $C_RS\n"
            buffer+="\e[2K${C_B} ${C_Y}·\e[$((build_progress * 30 / 100))b${C_B}>\e[34G${C_G}· ${C_P}%$build_progress\n"
            pln "$buffer\e[2A"
        fi
    fi
}
