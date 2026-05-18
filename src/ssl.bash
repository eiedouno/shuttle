if [[ "$1" == "" ]]; then
    epln "Command not specified." "Try 'shuttle help ssl'."
    exit 1
fi
[[ -z "$2" ]] && epln "Specify a project bro" "I don't wanna write an error message just for you being dumb." && exit 1
source ./src/ssl_install.bash "${@:2}"
