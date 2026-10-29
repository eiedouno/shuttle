run_project() {
    if [[ -d "$1" ]]; then
        VERBOSE=false source ./src/commands/build.bash "$@"

        plnv "${C_B}Running: $outfile ${passed_args[*]}\n"
        bash -c "$outfile ${passed_args[*]}"
    else
        VERBOSE=false source ./src/commands/build.bash "."
        plnv "${C_B}Running: $outfile ${passed_args[*]}\n"
        bash -c "$outfile ${passed_args[*]}"
    fi
}

read -ra passed_args <<<"$@"

run_project "$@"
