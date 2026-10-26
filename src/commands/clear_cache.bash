rm -rf "$HOME/.cache/shuttle" || {
    epln "Unable to reset cache" "Try reseting it yourself with:\n\nrm -rf $HOME/.cache/shuttle"
    exit 1
}
pln "${C_G}Successfully reset cache\n${C_B}If something else is weird try updating: 'shuttle -u'\n"
