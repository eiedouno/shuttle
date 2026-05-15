printf "\e[34m\e[1m\e[4m
Usage:\e[0m shuttle install [options] [directory|project]

\e[34m\e[1m\e[4m
Options:\e[0m
    -f, --force			Do not ask for confirmation.
    -m, --minimal		Use the least amount of spacing possible in the build.
    -p, --portable		Add extra checks and handlers for on-the-go builds.
    -q, --quiet			Be less verbose.
    --small			Same as --minimal.
\e[34m\e[1m\e[4m
Arguments:\e[0m
    [directory]  The directory of the shuttle script to build and install. Leave blank for current directory.
    [project]  The id of the project to download, build and install from the Shuttle Script Library.
\e[0m"
