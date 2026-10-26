doc_url="https://eiedouno.github.io/shuttle"
if command -v xdg-open >/dev/null; then
    xdg-open "$doc_url"
else
    plnq "${C_B}Open this in your web browser to learn more about shuttle:\n${C_G}$doc_url\n"
fi
