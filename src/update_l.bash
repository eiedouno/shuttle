mkdir -p "$HOME/.cache/shuttle/"
curl -fsSL https://raw.githubusercontent.com/eiedouno/shuttlescript/main/library/ssl.json > $ssl
if [[ "$?" != "0" ]]; then
    printf "${C_ERR}Failed to update the Shuttle Script Library.$C_RS\n${C_B}Internet?\nIs it slow?\n$C_RS"
    exit 1
fi
printf "${C_B}Successfully updated the library.\n$C_RS"
