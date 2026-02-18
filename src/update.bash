main() {
    rm -rf ~/.cache/shuttle/shuttle
    git clone https://github.com/eiedouno/shuttle ~/.cache/shuttle/shuttle || xx_failed
    source ./src/install.bash ~/.cache/shuttle/shuttle
}

main "$@"
