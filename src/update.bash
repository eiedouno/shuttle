work_directory="$HOME/.cache/shuttle/shuttle"
if [[ -d "$work_directory" ]]; then
    failsafe git -C "$work_directory" reset origin --hard >/dev/null 2>&1
    failsafe git -C "$work_directory" clean -fd >/dev/null 2>&1
    failsafe git -C "$work_directory" pull >/dev/null 2>&1
else
    failsafe git clone https://github.com/eiedouno/shuttle "$work_directory" --depth 1
fi

new_shuttle_version=$(jq -r .version "$HOME/.cache/shuttle/shuttle/shuttle.json")
if [[ "$new_shuttle_version" == "$shuttle_version" ]]; then
    plnq "${C_B}Already up to date!\nTo override, use 'shuttle install shuttle'\n"
    exit 0
fi

FORCE=true source ./src/commands/install.bash "$HOME/.cache/shuttle/shuttle" || failed
