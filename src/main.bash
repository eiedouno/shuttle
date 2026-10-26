trap 'printf >&2 "\e[?25h"; exit 1' SIGINT SIGTERM

source ./src/init.bash
source ./src/common.bash
source ./src/eval_input.bash "$@"
plnqa "\e[?25h"
