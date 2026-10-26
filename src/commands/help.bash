if [[ -z "$1" ]]; then
    source ./lib/texts/usage.bash
    exit 0
fi

help() {
    copy_aarray commands help_entries
    help_entries[all]=1
    if [[ "${help_entries[$1]}" == "1" ]]; then
        source "./lib/texts/help/$1.bash"
        exit 0
    else
        epln "Command not known: '$1'" "Try 'shuttle -h'"
        exit 1
    fi
}

help "$@"
