printf "\e[34m\e[1m\e[4m
Usage:\e[0m shuttle build [options] [directory]

\e[34m\e[1m\e[4m
Options:\e[0m
    -f, --force         Do not ask for confirmation.
    -m, --minimal       Use the least amount of spacing possible in the build. (remove white-space)
    -r, --release       Optimize build and add extra checks and handlers for build distribution.
    -q, --quiet         Be less verbose.
    -v, --verbose       Be more verbose.
    --small             Same as --minimal.
    --slow              Be slow.
\e[34m\e[1m\e[4m
Arguments:\e[0m
    [directory]  The directory of the shuttle script to build. Leave blank for current directory.
\e[0m"
