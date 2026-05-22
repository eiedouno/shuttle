main() {
    if [[ -f "/usr/local/bin/$1" ]]; then
        if rm "/usr/local/bin/$1"; then
            pln "${C_P}Successfully uninstalled $1.\n$C_RS"
        else
            bruh
        fi
    else
        epln "File /usr/local/bin/$1 is already uninstalled."
    fi
}

bruh() {
    epln "Unable to uninstall." "Try running as root or changing the ownership of '/usr/local/bin'."
    exit 1
}

main "$@"
