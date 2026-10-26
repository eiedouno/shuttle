printf '%b' "${C_G}Uninstall a shell script
$C_B$C_BLD$C_UL
Usage:$C_RS ${C_P}shuttle uninstall [${C_G}options${C_P}] [${C_G}file${C_P}]
$C_B$C_BLD$C_UL
Options:$C_RS
    ${C_G}-f, --force         ${C_RS}Do not ask for confirmation ${C_LHT}(default: no)$C_RS
    ${C_G}-q, --quiet         ${C_RS}Be less verbose ${C_LHT}(default: no)$C_RS
    ${C_G}-v, --verbose       ${C_RS}Be more verbose ${C_LHT}(default: no)$C_RS
$C_B$C_BLD$C_UL
Arguments:$C_RS
    ${C_G}file    ${C_RS}The id (which is the file) of the project to delete

${C_B}Uninstalls from ${C_G}\$HOME/.local/bin/${C_B} if running as a user and ${C_G}/usr/local/bin/${C_B} if running as ${C_R}root${C_B}.$C_RS
${C_B}If no argument is passed, it uninstalls the project in the current directory by reading it's name declared inside ${C_G}shuttle.json$C_RS
$C_RS"
