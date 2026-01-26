main() {
    rm -rf ~/.cache/shuttle/shuttle
    chk_cmp
    git clone https://github.com/eiedouno/shuttle ~/.cache/shuttle/shuttle
    chk_cmp
    source ./src/install.bash ~/.cache/shuttle/shuttle
}

main "$@"
