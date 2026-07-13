printf '%b' "__SHUTTLE_INIT() {
    while read -r entry; do
        if ! command -v \"\$entry\" >/dev/null && [[ -n \"\$entry\" ]]; then
            fail=1
            err+=(\"\$entry\")
        fi
    done <<<\"$(printf '%s\n' "$deps" | sed 's/$/\\n/' | tr -d '\n')\"

    if [[ \"\$fail\" == \"1\" ]]; then
        printf '%b' \"The following dependencies were not found on your system:\\\\n\"
        printf '\\\\n%b\\\\n' \"\${err[@]}\"
        printf '%b' \"\\\\nPlease install them with your package manager.\\\\n\"
        exit 1
    fi

    if [[ \"\$1\" == \"__BUILD_INFO!\" ]]; then
        local __buildshuttleversion=\"$(printf $shuttle_version)\"
        local __buildversion=\"$(printf ${shuttle_json_version:-"(none)"})\"
        local __buildid=\"$(printf ${shuttle_json_id:-"(null)"})\"
        local __buildflags=\"$(printf ${buildinfomsg:-"(null)"})\"
        printf '%b' \"[SHUTTLE] Build info:\\\\nshuttle version:\$__buildshuttleversion\\\\nbuild version:\$__buildversion\\\\nbuild id: \\\"\$__buildid\\\"\\\\nbuild opts: \\\"\$__buildflags\\\"\\\\n\"
        exit
    fi
}
"
