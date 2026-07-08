printf "\e[34m\e[1m\e[4m
Usage:\e[0m shuttle install [options] [directory|project]

\e[34m\e[1m\e[4m
Options:\e[0m
    -f, --force			Do not ask for confirmation.
    -m, --minimal		Use the least amount of spacing possible in the build.
    -p, --portable		Add extra checks and handlers for on-the-go builds.
    -q, --quiet			Be less verbose.
    -v, --verbose		Be more verbose.
    --small			Same as --minimal.
\e[34m\e[1m\e[4m
Arguments:\e[0m
    [directory]  The directory of the shuttle script to build and install. Leave blank for current directory.
    [project]  The id of the project to download, build and install from the Shuttle Script Library.

SSL scripts are always checked and installed with least priority. Make sure there are no files with the same name as your desired SSL script in the current directory before attempting to install.
Use 'shuttle ssl install' instead for direct ssl interation.
\e[0m"
