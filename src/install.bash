main() {
    RELEASE=true
    if [ -d "$1" ]; then

        dir="$(realpath "$1")"
        source ./src/build.bash "$dir"
        install "$outfile"

    elif [ -f "$1" ]; then
        install "$1"
    elif [[ "$1" == "" ]]; then
        source ./src/build.bash "."
        install "$outfile"
    else
        source ./src/ssl_install.bash "$1"
    fi
}

install() {
    local file="$1"
    local filename
    filename=$(basename "$file")
    filename="${filename%.bash}"
    cp "$file" "/usr/local/bin/$filename" || {
        epln "Unable to install file." "Try running as root or changing ownership of '/usr/local/bin'"
        exit 1
    }
    plnq "${C_G}Successfully installed $filename.\n$C_RS"
}

main "$@"
