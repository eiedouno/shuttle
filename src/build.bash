if [[ "$1" == "" ]]; then
    dir="$PWD"
else
    dir="$(realpath $1)"
fi

name="$(basename $dir)"

if [[ -f "$dir/src/main.bash" ]]; then
    source ./src/build/filter.bash
else
    printf "${C_ERR}Unable to find shuttle project in directory.$C_RS\n${C_B}Make sure you're inside the root of your project.\n$C_RS"
fi
