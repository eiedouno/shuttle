create_colors() {
    declare -a colors=(R G Y B P BLD LHT UL RS)
    declare -a colors_sig=(31 32 33 34 35 1 2 4 0)
    declare index=0
    for color in "${colors[@]}"; do
        printf -v "C_$color" "%s" "\e[${colors_sig[$index]}m"
        ((index++))
    done

    C_ERR="$C_R$C_BLD"
}

declare -g -A options=(
    [help]="./src/commands/help.bash"
    [h]=help
    [interactive]="./src/commands/cli.bash"
    [cli]=interactive
    [i]=interactive
    [version]="./lib/texts/version.bash"
    [update]="./src/update.bash"
    [u]=update
    [sync]="./src/update_ssl.bash"
    [y]=sync
    [clear-cache]="./src/commands/clear_cache.bash"
)

declare -g -A flags=(
    [link]=LINK
    [l]=LINK
    # [release]=RELEASE
    # [r]=RELEASE
    [force]=FORCE
    [f]=FORCE
    [verbose]=VERBOSE
    [v]=VERBOSE
    [quiet]=QUIET
    [q]=QUIET
    [slow]=SLOW
)

declare -g -A commands=(
    [add]=1
    [help]=1
    [build]=1
    [b]=build
    [docs]=1
    [new]=1
    [init]=1
    [run]=1
    [r]=run
    [remove]=1
    [install]=1
    [uninstall]=1
)

shuttle_version="0.1"
ssl="$HOME/.cache/shuttle/ssl.json"

# If output is a terminal, then create the color values (for pipeing and redirecting)
if [[ -t 1 ]]; then
    create_colors
fi

# Source config if it exists, else, create it
if [[ -f "$HOME/.config/shuttle/shuttle.conf" ]]; then
    . "$HOME/.config/shuttle/shuttle.conf"
else
    mkdir -p "$HOME/.config/shuttle/"
    touch "$HOME/.config/shuttle/shuttle.conf"
fi
