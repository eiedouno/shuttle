main() {
    if [[ -f "/usr/local/bin/$1" ]]; then
	if rm "/usr/local/bin/$1"; then
	    pln "${C_P}Successfully uninstalled $1.\n$C_RS"
	else
	    bruh
	fi
    else
	bruh
    fi
}

bruh() { 
    pln "${C_ERR}Unable to uninstall.${C_RS}\n${C_B}Try running as root or changing the ownership of '/usr/local/bin'.\nOr the file might already be uninstalled.\n$C_RS"
    exit 1
}

main "$@"
