---
icon: lucide/link
---

# :lucide-link: Sourcing Files

Sourcing different files inside a codebase is the entire point of shuttle. It's how shuttle is able to be useful at all.

## :lucide-circle-question-mark: What is sourcing?

If you don't know, the `source` command is a shell-builtin that allows you to run commands from another file, and keep the changes made to your shell. Shuttle uses it to split the code between multiple files.

```bash title="View the 'source' commands help page inside bash"
help source
```

## :lucide-file-input: Sourcing a project file

!!! note "This concept is explained in-depth on it's [dedicated concept page](../concept/building.md#sourcing)."

You can source a project file with two simple rules.

* The sourced file passed to `source` must always start with `./` and end in `.bash`
* The sourced file path must start from the project root

The cool thing about shuttle is that all file references starting with `./` and ending with `.bash` will be converted to their function counterparts when building. This allows you to both source a full path[^1] (hard-linked) and a relative or partial path (soft-linked) to a file.

[^1]: As long as it starts from the project root with a `./`

=== "Hard-linked example"

    This will resolve to `./src/another_file.bash` in source and `src_another_file` when compiled.

    ```bash hl_lines="3"
    main() {
        echo "hi I'm code"
        source ./src/another_file.bash
    }

    main
    ```

=== "Partially soft-linked example"

    This will resolve to `./src/another_file.bash` in source and `src_another_file` when compiled.

    ```bash hl_lines="4 8"
    main() {
        echo "hi I'm code"

        relative_path="another_file"

        echo "hi I'm more code"

        source ./src/$relative_path.bash
    }

    main
    ```

=== "Fully soft-linked example"

    This will resolve to `./src/another_file.bash` in source and `src_another_file` when compiled.

    ```bash hl_lines="4 8"
    main() {
        echo "hi I'm code"

        relative_path="./src/another_file.bash"

        echo "hi I'm more code"

        source $relative_path
    }

    main
    ```

All of these are fully valid in shuttle, thanks to some clever regex.

## :lucide-bug: Debugging

!!! info "Be sure to report bugs to the [issues page](https://github.com/eiedouno/shuttle/issues) on GitHub!"

Not every single situation will work, we understand that. Luckily, we thought of this before it happened. We've created an incredibly verbose 'verbose' mode in shuttle's build command for the purpose of debugging and analysis. Every `source` conversion is logged when this mode is turned on, allowing you to see and change the necessary things to get it working again.

```bash title="shuttle's build command with the verbose flag"
shuttle build --verbose
# shortened: shuttle b -v
```

Beware though, this is stupidly verbose.
