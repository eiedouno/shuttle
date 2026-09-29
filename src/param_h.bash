setFlags_build() {
    evalFlags() {
        for f in "$@"; do
            if [[ "$f" == --* ]]; then
                con="${f#--}"
                flags_h2
            elif [[ "$f" == -* ]]; then
                con="${f#-}"
                flags_h1
            else
                leftoverFlags="$f"
            fi

        done
    }

    flags_h1() {
        while IFS= read -r -n1 char; do
            [[ -z "$char" ]] && continue

            case $char in
            q)
                QUIET=true
                ;;
            r)
                RELEASE=true
                ;;
            m)
                MINIMAL=true
                ;;
            f)
                FORCE=true
                ;;
            v)
                VERBOSE=true
                ;;
            *)
                epln "Unknown option '-$char'" "Try 'shuttle help <command>'" && exit 1
                ;;
            esac
        done <<<"$con"
    }

    flags_h2() {
        case $con in
        quiet)
            QUIET=true
            ;;
        release)
            RELEASE=true
            ;;
        minimal)
            MINIMAL=true
            ;;
        small)
            MINIMAL=true
            ;;
        force)
            FORCE=true
            ;;
        verbose)
            VERBOSE=true
            ;;
        slow)
            SLOW=true
            ;;
        *)
            epln "Unknown option '--$con'" "Try 'shuttle help <command>'" && exit 1
            ;;
        esac
    }
    evalFlags "$@"

    if [[ "$VERBOSE" == "true" && "$QUIET" == "true" ]]; then
        epln "10IQ idiot managing the software." "Dog, you put verbose and quiet together DX" && exit 1
    fi
}

handleOptions() {
    case "$1" in

    -i | --interactive)
        source ./src/cli.bash
        ;;

    -h | --help)
        source ./lib/texts/usage.bash
        ;;

    -v | --version)
        source ./lib/texts/version.bash
        ;;

    -u | --update)
        source ./src/update.bash
        ;;

    -y | --update-library)
        source ./src/update_l.bash
        (($# >= "2")) && handleCommands "${@:2}"
        ;;

    --clear-cache)
        source ./src/reset.bash
        ;;

    *)
        handleCommands "$@"
        ;;
    esac
}

handleCommands() {
    case "$1" in

    add)
        source ./src/addToProject.bash "${2:+"${@:2}"}"
        ;;

    help)
        source ./src/help.bash "$@"
        ;;

    b | build)
        setFlags_build "${2:+"${@:2}"}"
        source ./src/build.bash "$leftoverFlags"
        ;;

    docs)
        source ./src/docs.bash
        ;;

    new)
        source ./src/newProject.bash "$2"
        ;;

    init)
        source ./src/initProject.bash
        ;;

    r | run)
        source ./src/run.bash "$@"
        ;;

    install)
        setFlags_build "${2:+"${@:2}"}"
        source ./src/installProject.bash "$leftoverFlags"
        ;;

    uninstall)
        source ./src/uninstallProject.bash "$2"
        ;;

    ssl)
        source ./src/ssl.bash "${2:+"${@:2}"}"
        ;;

    *)
        epln "Command not known '$1'." "Try 'shuttle -h'"
        exit 1
        ;;
    esac
}

if [[ "$#" == "0" ]]; then
    epln "Command not specified." "Try 'shuttle -h'."
    exit 1
fi

handleOptions "$@"
