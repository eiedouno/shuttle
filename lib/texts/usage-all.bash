printf '%b' "\e[34m\e[1m\e[4m
Usage:\e[0m
	shuttle [option]
	shuttle [command]
	shuttle -y [command]
\e[34m\e[1m\e[4m
Options:\e[0m
    --clear-cache		Reset cache of shuttle
    -h, --help			Print help
    -u, --update		Fetch the latest update
    -y, --update-library	Update the library
    -v,	--version		Print version, info and exit
\e[34m\e[1m\e[4m
Commands:\e[0m
    build, b		Build the current project
    docs		Open the online documentation
    new			Create a new project
    init		Create a new project in the current directory
    run, r		Build and run the current project
    install		Build and install the project
    uninstall		Uninstall the project
\e[35m
See 'shuttle help <command>' for more information on a specific command.
\e[0m"
