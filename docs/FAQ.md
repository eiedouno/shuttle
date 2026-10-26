---
icon: lucide/circle-question-mark
---

??? info "What shells does shuttle support?"

    Shuttle supports `sh`, `bash`, and (partially) `zsh` scripts. By default, shuttle will install projects as bash scripts.  
    Shuttle was designed for bash though, so bash is it's primary workspace. Shuttle was written in bash.

??? info "I installed a project, but I can't run it!"

    Shuttle installs projects to `$HOME/.local/bin/` if you're running as a user, and `/usr/local/bin/` if you're running as root.  
    Ensure that those directories are inside your path.

    ??? info "How do I do that?"

        ??? info inline end "Whats my shell's profile?"

            `~/.bash_profile` for `bash`  
            `~/.zprofile` for `zsh`  

        Add the following to your shell's profile:

        ```bash
        export PATH="$PATH:$HOME/.local/bin"
        export PATH="$PATH:/usr/local/bin"
        ```

        Then restart your session. (logout, then login)
