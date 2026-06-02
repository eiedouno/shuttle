main() {
    [[ -z "$1" ]] && epln "Specify something to uninstall." && exit 1

    if [[ -f "/usr/local/bin/$1" ]]; then
        if rm "/usr/local/bin/$1"; then
            pln "${C_P}Successfully uninstalled $1.\n$C_RS"
        else
            bruh
        fi
    else
        epln "File /usr/local/bin/$1 does not exist."
    fi
}

bruh() {
    epln "Unable to uninstall." "Try changing the ownership of '/usr/local/bin'.\n\nsudo chown eiedouno:eiedouno /usr/local/bin"
    exit 1
}

main "$@"
