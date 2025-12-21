main() {
    if [[ -f "/usr/local/bin/$1" ]]; then
	rm "/usr/local/bin/$1"
	if [[ $? == 0 ]]; then
	    printf "\e[32mSuccessfully uninstalled $1.\n\e[0m"
	else
	    bruh
	fi
    else
	bruh
    fi
}

bruh() { 
    printf "\e[31mUnable to uninstall.\n\e[34mTry running as root or changing the ownership of '/usr/local/bin'.\n\e[0m"
    exit 1
}

main "$@"
