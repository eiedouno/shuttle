rm -rf $HOME/.cache/shuttle || {
    epln "Unable to reset cache." "Try reseting it yourself with:\n\nrm -rf $HOME/.cache/shuttle"
    exit 1
}
epln "Successfully reset cache." "( rm -rf $HOME/.cache/shuttle )"
