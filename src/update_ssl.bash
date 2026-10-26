mkdir -p "$HOME/.cache/shuttle/"
if ! curl -fsSL https://raw.githubusercontent.com/eiedouno/shuttlescript/main/library/ssl.json >"$ssl"; then
    epln "Failed to update the Shuttle Script Library" "Is shuttle up to date? 'shuttle -u'"
    exit 1
fi

pln "${C_G}Successfully updated the Shuttle Script Library\n"
