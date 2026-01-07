main() {
    initvars
    source ./src/param_h.bash "$@"
}

initvars() {
    shuttle_version="0.1"
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

main "$@"
