main() {
    if [[ -d "$HOME/.cache/shuttle/shuttle" ]]; then
	cd ~/.cache/shuttle/shuttle || xx_failed
	git reset origin --hard >/dev/null
	git clean -f >/dev/null
	git pull >/dev/null
    else
	git clone https://github.com/eiedouno/shuttle $HOME/.cache/shuttle/shuttle >/dev/null || xx_failed
    fi

    nsv=$(jq -r .version "$HOME/.cache/shuttle/shuttle/shuttle.json")
    if [[ "$nsv" == "$shuttle_version" ]]; then
	pln "${C_B}Already up to date!\nTo override, use 'shuttle ssl install shuttle'\n"
	exit
    fi

    source ./src/install.bash "$HOME/.cache/shuttle/shuttle" || xx_failed
}

main "$@"
