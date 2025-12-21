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
	printf "\e[31mUnknown file type '$1'.\n\e[0m"
	exit 1
    fi
}

install() {
    local file="$1"
    local filename=$(basename "$file")
    cp "$file" "/usr/local/bin/$filename"
    if [[ $? != 0 ]]; then
	printf "\3[31mUnable to install file.\n\e[34mTry running as root or changing ownership of '/usr/local/bin'\n\e[0m"
    fi
}

main
