printf '%b' "${C_G}The script file package manager | Shuttle version $shuttle_version
$C_B$C_BLD$C_UL
Usage:$C_RS
    ${C_P}shuttle [${C_G}options${C_P}] <${C_G}command${C_P}>
$C_B$C_BLD$C_UL
Options:$C_RS
    ${C_G}-h, --help              ${C_RS}Print help
    ${C_G}-i, --interactive       ${C_RS}Launch cli
    ${C_G}--cli                   ${C_RS}Launch cli ${C_LHT}(same as --interactive)$C_RS
    ${C_G}-u, --update            ${C_RS}Fetch the latest update
    ${C_G}-y, --sync              ${C_RS}Update the library
    ${C_G}--version               ${C_RS}Print version, info and exit

    ${C_G}-q, --quiet             ${C_RS}Be less verbose
    ${C_G}-v, --verbose           ${C_RS}Be more verbose
    ${C_G}-f, --force             ${C_RS}Do not ask for confirmation

$C_B$C_BLD$C_UL
Extra options:$C_RS
    ${C_G}--clear-cache           ${C_RS}Clear shuttle's cache ${C_LHT}(rm -rf $HOME/.cache/shuttle/)$C_RS
    ${C_G}--slow                  ${C_RS}Be slow ${C_LHT}(only works with install, build, and run commands)$C_RS

$C_B$C_BLD$C_UL
Commands:$C_RS
    ${C_G}add             ${C_RS}Add a library to the current project
    ${C_G}remove          ${C_RS}Remove a library from the current project
    ${C_G}docs            ${C_RS}Open the online documentation
    ${C_G}new             ${C_RS}Create a new project
    ${C_G}init            ${C_RS}Create a new project in the current directory
    ${C_G}build, b        ${C_RS}Build the current project
    ${C_G}run, r          ${C_RS}Build and run the current project
    ${C_G}install         ${C_RS}Build and install a project
    ${C_G}uninstall       ${C_RS}Uninstall a project
$C_B
See 'shuttle help <command>' for more information on a specific command.
See 'shuttle help all' for all commands.
$C_RS"
