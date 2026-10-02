if [[ "$1" == "" ]]; then
    epln "Command not specified." "Try 'shuttle help ssl'."
    exit 1
fi
[[ -z "$2" ]] && epln "Specify a project bro" && exit 1
source ./src/ssl_install.bash "${@:2}"
