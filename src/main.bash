main() {
    initvars
    source ./src/param_h.bash "$@"
}

initvars() {
    shuttle_version="0.3"
    ssl="$HOME/.cache/shuttle/ssl.json"
    rows=$(tput lines)
    cols=$(tput cols)

    # ANSI escape sequences for colors and formatting.
    C_G='\e[32m'
    C_R='\e[31m'
    C_Y='\e[33m'
    C_B='\e[34m'
    C_P='\e[35m'
    C_RS='\e[0m'
    C_BLD='\e[1m'
    C_LHT='\e[2m'
    C_ERR='\e[31m\e[1m'
}

ConvertFrom-JSON() {
    local XXjsonfile="$1"
    local XXjsonfilename=$(basename "$1")

    for key in $(jq -r 'keys[]' "$XXjsonfile"); do
	local value
	value=$(jq -r --arg k "$key" '.[$k]' "$XXjsonfile")

	local XXkeyname="${XXjsonfilename%*.*}_$key"
	printf -v "$XXkeyname" '%s' "$value"
    done
}

xx_failed() {
    epln "An unknown error occurred."
    exit 1
}

pln() {
    local safe=${*//%/%%}
    printf '%b\e[0m' "$safe"
}

plnq() {
    if [[ $QUIET != "true" ]]; then
	pln "$@"
    fi
}

epln() {
    local safe1=${1//%/%%}
    local safe2=${2//%/%%}
    printf "\n\e[31m\e[1m%b\e[0m\n\e[34m%b\n\e[0m" "$safe1" "$safe2"
}

main "$@"
