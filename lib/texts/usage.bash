printf '%b' "\e[32meiedouno Shuttle, version $shuttle_version
------------------------------------
The script file package manager.
\e[34m\e[1m\e[4m
Usage:\e[0m
	shuttle [option]
	shuttle [command]
	shuttle -y [command]
\e[34m\e[1m\e[4m
Options:\e[0m
    -h, --help              Print help
    -i, --interactive       Launch cli
    -u, --update            Fetch the latest update
    -y, --update-library    Update the library
    -v, --version           Print version, info and exit
\e[34m\e[1m\e[4m
Commands:\e[0m
    add             Add a library to the current project
    build, b        Build the current project
    docs            Open the online documentation
    new             Create a new project
    init            Create a new project in the current directory
    run, r          Build and run the current project
    install         Build and install the project
    uninstall       Uninstall the project
    ssl             Interact with the Shuttle Script Library
\e[35m
See 'shuttle help <command>' for more information on a specific command.
See 'shuttle help all' for all commands.
\e[0m"
