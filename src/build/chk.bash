ConvertFrom-JSON "$dir/shuttle.json"
get_proj_type "$dir/shuttle.json"

[[ $PROJECT_TYPE == "library" && $FORCE != "true" ]] && epln "Libraries don't need to and it isn't useful to be built.\nIn most cases the built file isn't executable due to incorrect calling." "To override this use -f" && exit 1

deps_chk "$dir/shuttle.json"
raw_deps_chk "$dir/shuttle.json"
