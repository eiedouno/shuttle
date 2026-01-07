main() {
    ConvertFrom-JSON "$dir/shuttle.json"
    deps_chk "$dir/shuttle.json"
    raw_deps_chk "$dir/shuttle.json"
}

deps_chk() {
    local file="$1"
    local key="deps"
    local watch
    local err

    if jq -e ".${key}" "$file" >/dev/null 2>&1; then
	while read -r entry; do
	    if ! command -v "$entry" >/dev/null; then
		watch=1
		err+=("$entry")
	    fi
	done < <(jq -r ".${key}[]" "$file")
    fi

    if [[ "$watch" == "1" ]]; then

	printf "${C_B}Fetching dependencies:\n"
	printf '%b\n' "${err[@]}"

	for f in "${err[@]}"; do
	    source ./src/install.bash "$f"
	done
    fi
}

raw_deps_chk() {
    local file="$1"
    local key="raw_deps"
    local fail
    local err

    if jq -r ".${key}[]" "$file" >/dev/null 2>&1; then

	while read -r entry; do
	    if ! command -v "$entry" >/dev/null; then
		fail=1
		err+=("$entry")
	    fi
	done < <(jq -r ".${key}[]" "$file")
    fi

    if [[ "$fail" == "1" ]]; then
	printf "${C_ERR}The following dependencies were not found on your system:\n"
	printf '%b\n' "${err[@]}"
	printf "${C_B}Please install them with your package manager.\n$C_RS"
	exit 1
    fi
}

main
