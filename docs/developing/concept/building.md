---
icon: lucide/blocks
---

# :lucide-blocks: Building

## :lucide-cog: Core

Shuttle's build system is the core part of shuttle and it's usage benefits. It takes a codebase and compiles it into a single script file, where each file becomes a function. It uses regex and other logic to detect `source` calls and Bash's parameter expansion system to convert those into their proper function counterparts.

## :lucide-cpu: [How it works](../../tech/how/building.md)

## :lucide-terminal: Command

Shuttle's `build` command takes one argument: `directory`. By default it's `$PWD`, so a simple  
`shuttle build` will build the project, just like cargo. Shuttle will error if the directory doesn't have a project inside it.

```bash title="Build a shuttle project in the directory 'directory'"
shuttle build directory
```

The `--force`, `--quiet` and `--verbose` flags are implemented. A progress bar will be visible unless `--quiet` or `--verbose` is specified.

!!! warning "Warning! The build output file (`project.bash`) will always be overwritten when building without prior notice."
