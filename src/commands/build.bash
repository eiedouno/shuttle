source ./src/commands/build/common.bash

build_start_msg() {
    plnq "${C_B}Building $PROJECT_NAME\n"
}

build_finish_msg() {
    plnq "\n\n\n${C_G}Successfully built $PROJECT_NAME${PROJECT_ID:+" (${PROJECT_ID})"} ${C_LHT}| ${#PROJECT_FILES[@]} files\n"
    plnqa "\e[?25h"
}

init_progbar() {
    build_steps=4
    plnqa "\e[?25l"
    get_term_size
}

get_working_dir "$1"

source ./src/commands/build/check.bash

build_start_msg

plnqa "\n"

init_progbar
build_step=1
build_step_desc="Verifying Dependencies"
build_progress=0
progbar_update

check_deps "$working_directory/shuttle.json"
check_raw_deps "$working_directory/shuttle.json"

source ./src/commands/build/filter.bash
source ./src/commands/build/compile.bash

printf "src_main \"\$@\"\n" >>"$outfile"
chmod +x "$outfile"

((build_step++))
build_step_desc="Compiled $PROJECT_NAME"
build_diff="${C_G}${C_LHT}0 errors${C_RS}"
build_progress=100
progbar_update

build_finish_msg
