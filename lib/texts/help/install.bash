printf '%b' "${C_G}Install a shell script
$C_B$C_BLD$C_UL
Usage:$C_RS ${C_P}shuttle install [${C_G}options${C_P}] [${C_G}project${C_P}|${C_G}directory${C_P}|${C_G}url${C_P}]
$C_B$C_BLD$C_UL
Options:$C_RS
    ${C_G}-f, --force         ${C_RS}Do not ask for confirmation ${C_LHT}(default: no)$C_RS
    ${C_G}-l, --link          ${C_RS}Symlink the installed script to it's source code instead of building. ${C_LHT}(default: no)$C_RS
    ${C_G}-q, --quiet         ${C_RS}Be less verbose ${C_LHT}(default: no)$C_RS
    ${C_G}-v, --verbose       ${C_RS}Be more verbose ${C_LHT}(default: no)$C_RS
$C_B$C_BLD$C_UL
Arguments:$C_RS
    ${C_G}project    ${C_RS}The id of the project to download, build and install from the Shuttle Script Library$C_RS
    ${C_G}directory  ${C_RS}The directory of the shuttle script to build and Install ${C_LHT}(default: \$PWD)$C_RS
    ${C_G}url        ${C_RS}The url of a git repository to build and install ${C_LHT}(starting with https://)$C_RS

${C_B}Defaults to building a local project (in ${C_G}\$PWD${C_B}) unless ${C_G}project${C_B} or ${C_G}url${C_B} is specified.
${C_B}Installs to ${C_G}\$HOME/.local/bin/${C_B} if running as a user and ${C_G}/usr/local/bin/${C_B} if running as ${C_R}root${C_B}.$C_RS
$C_RS"
