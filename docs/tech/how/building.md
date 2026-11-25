---
icon: lucide/cpu
---

# :lucide-cpu: How it works

The first step in shuttle's build process is creating an array of all files ending in `.bash` of the project. For each file, it first creates a function name based on the file name, and creates a function declaration inside `project.bash` with that name. It then goes line-by-line detecting `source` calls and project file references converting them into their function counterparts. Those lines are outputted to `project.bash` before repeating with the next file.

After each file has been handled, the 'executable' flag is set and the entry call is added: `src_main "$@"`.

## :lucide-move-horizontal: Source call / file reference conversion {#sourcing}

### :lucide-link: Source calls

The `source` keyword is simply deleted wherever it is seen inside a project. It does not need to have a file reference after it for it to be converted (in this case, deleted) in the line.

??? note "Well than how would I source a file when compiled!?"

    Shuttle doesn't modify the `.` command, which is functionally the same as the `source` command. Use that.

    Example:

    ```bash title="Bad example: the source keyword gets removed"
    source $HOME/.config/project/project.conf
    ```

    ```bash title="Working example: uses '.' command"
    . "$HOME/.config/project/project.conf"
    ```

### :lucide-file-cog: File references

Shuttle detects file references by looking for the `./` followed by a `.bash`. If it is detected, that snippet will be replaced with it's function counterpart. The process for converting a file path to a function name starts with removing the `./` from the front. It then replaces all slashes `/` inside the path with underscores `_`, then strips the `.bash` from the front.

??? warning "Warning! Because slashes `/` are converted to underscores `_`, it is possible to have conflicting files!"

    Examples:

    `./src/another_file.bash` converted --> `src_another_file`  
    `./src/another/file.bash` converted --> `src_another_file`

    `./src/extra_example.bash` converted --> `src_extra_example`  
    `./src/extra/example.bash` converted --> `src_extra_example`

    Both examples will have one file overshadowed and cause missing code.

### :lucide-flask-conical: Examples

=== "Hard-linked source call"

    ```bash hl_lines="2" title="Source code"
    ...
        source ./src/another_file.bash
    ...
    ```
 
    Shuttle checks for a `.bash` in front of the source call. In this case it finds one. The source keyword is then deleted from the line, and the remaining `./src/another_file.bash` is converted into it's function counterpart.
 
    ```bash hl_lines="2" title="Compiled code"
    ...
         src_another_file
    ...
    ```


=== "Partially soft-linked source call"

    ```bash hl_lines="3" title="Source code"
    ...
        variable="another_file"
        source ./src/$variable.bash
    ...
    ```
 
    Shuttle checks for a `.bash` in front of the source call. In this case it finds one. The source keyword is then deleted from the line, and the remaining `./src/$variable.bash` is converted into it's function counterpart. The `$variable` is kept, as shuttle ignores it.

    `$variable` is kept unchanged.
 
    ```bash hl_lines="3" title="Compiled code"
    ...
        variable="another_file"
         src_$variable
    ...
    ```

    Bash reads this as `src_another_file`.

=== "Soft-linked source call"

    ```bash hl_lines="3" title="Source code"
    ...
        variable="./src/another_file.bash"
        source $variable
    ...
    ```
 
    For the file reference (after `variable=`), shuttle detects `./` then `.bash` and converts it into it's function counterpart.

    Shuttle checks for a `.bash` in front of the source call. If there isn't one, the `source` keyword is simply removed.

    ```bash hl_lines="3" title="Compiled code"
    ...
        variable="src_another_file"
         $variable
    ...
    ```

## Relevant Files

The files related to this concept inside shuttle's codebase.

[`src/commands/build.bash`](https://github.com/eiedouno/shuttle/blob/main/src/commands/build.bash) main orchestrator  
[`src/commands/build/filter.bash`](https://github.com/eiedouno/shuttle/blob/main/src/commands/build/filter.bash) file discovery & filter system  
[`src/commands/build/compile.bash`](https://github.com/eiedouno/shuttle/blob/main/src/commands/build/compile.bash) build system
