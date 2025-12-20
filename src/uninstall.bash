main() {
    if [[ -f "/usr/local/bin/$1" ]]; then
	rm "/usr/local/bin/$1"
    else
	printf "\e[31mUnable to uninstall.\n\e[34mTry running as root or changing the ownership of '/usr/local/bin'."
	exit 1
    fi
}

main
