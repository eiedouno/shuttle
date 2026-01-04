main() {
    if [ -d "$1" ]; then

	if [[ "$1" == "" ]]; then
	    dir="$PWD"
	else
	    dir="$(realpath $1)"
	fi

	source ./src/build.bash "$dir"
	install "$outfile"

    elif [ -f "$1" ]; then
	install $1
    elif [[ "$1" == "" ]]; then
	source ./src/build.bash "."
	install $outfile
    else
	printf "${C_ERR}Unknown file type '$1'.$C_RS\n"
	exit 1
    fi
}

install() {
    local file="$1"
    local filename=$(basename "$file")
    filename="${filename%.bash}"
    cp "$file" "/usr/local/bin/$filename"
    if [[ $? != 0 ]]; then
	printf "${C_ERR}Unable to install file.$C_RS\n${C_B}Try running as root or changing ownership of '/usr/local/bin'\n$C_RS"
    else
	printf "${C_P}Successfully installed $filename.\n$C_RS"
    fi
}

main "$@"
