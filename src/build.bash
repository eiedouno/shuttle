if [[ "$1" == "" ]]; then
    dir="$PWD"
else
    dir="$(realpath $1)"
fi

name="$(basename $dir)"

source ./src/build/filter.bash
