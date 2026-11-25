---
icon: lucide/file-code-corner
---

# :lucide-file-code-corner: Sourcing

## :lucide-cog: Core

Sourcing is the entire point of shuttle. It allows the script author to split their code into multiple files, but have one "compiled" file once finished, just like writing for a compiled programming language.

## :lucide-cpu: How it works

!!! note "This concept is explained in-depth on it's [section inside the technical docs](../../tech/how/building.md#sourcing)."

Its incredibly straight-forward. Only 1 rule must be followed:

:material-information-outline:{ title="Important" } **The sourced file path must be a relative path, anchored to the project root[^1].**

[^1]: Or: The file path must start with `./`, where `.` is the project root.

Other than that, you're pretty much okay to do anything. The only thing to note is that **any slashes `/` get turned into underscores `_`**.

??? warning "Warning! Because slashes `/` are converted to underscores `_`, it is possible to have conflicting files!"

    Examples:

    `./src/another_file.bash` converted --> `src_another_file`  
    `./src/another/file.bash` converted --> `src_another_file`

    `./src/extra_example.bash` converted --> `src_extra_example`  
    `./src/extra/example.bash` converted --> `src_extra_example`

    Both examples will have one file overshadowed and cause missing code.

## :lucide-flask-conical: Examples


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
