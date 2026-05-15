mkdir -p "$HOME/.cache/shuttle/"
curl -fsSL https://raw.githubusercontent.com/eiedouno/shuttlescript/main/library/ssl.json > $ssl
if [[ "$?" != "0" ]]; then
    epln "Failed to update the Shuttle Script Library." "Internet?\nIs it slow?"
    exit 1
fi
pln "${C_G}Successfully updated the library.\n$C_RS"
