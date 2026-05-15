printf '%b' "chk_deps() {
    while read -r entry; do
	if ! command -v \"\$entry\" >/dev/null && [[ -n \"\$entry\" ]]; then
	    fail=1
	    err+=(\"\$entry\")
	fi
    done <<< \"$(printf '%s\n' "$deps" | sed 's/$/\\n/' | tr -d '\n')\"
    
    if [[ \"\$fail\" == \"1\" ]]; then
	printf '%b' \"The following dependencies were not found on your system:\\\\n\"
	printf '\\\\n%b\\\\n' \"\${err[@]}\"
	printf '%b' \"\\\\nPlease install them with your package manager.\\\\n\"
	exit 1
    fi
}
"
