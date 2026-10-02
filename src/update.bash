update() {
    if [[ -d "$HOME/.cache/shuttle/shuttle" ]]; then
        cd ~/.cache/shuttle/shuttle || handleFailed
        git reset origin --hard >/dev/null 2>&1
        git clean -f >/dev/null 2>&1
        git pull >/dev/null 2>&1
    else
        git clone https://github.com/eiedouno/shuttle "$HOME/.cache/shuttle/shuttle" >/dev/null 2>&1 || handleFailed
    fi

    nsv=$(jq -r .version "$HOME/.cache/shuttle/shuttle/shuttle.json")
    if [[ "$nsv" == "$shuttle_version" ]]; then
        pln "${C_B}Already up to date!\nTo override, use 'shuttle ssl install shuttle'\n"
        exit 0
    fi

    FORCE=true
    source ./src/installProject.bash "$HOME/.cache/shuttle/shuttle" || handleFailed
}

update
