---
icon: lucide/house-cog
---

# :lucide-house-cog: Installing

## :lucide-cog: Core

Shuttle's install function builds the project it's pointed to, and copies the built file into `$HOME/.local/bin` if you aren't running as root and `/usr/local/bin` if you are.

## :lucide-terminal: Command

!!! note "Note! As of now, shuttle only supports `https://` links."

Shuttle's `install` command takes one argument. It can be a project's git repository URL, an ID from the SSL, or a local directory on the system.

If a git URL is passed, shuttle uses the git CLI to clone the repository to `$HOME/.cache/shuttle/downloads/<repository name>/`, and uses that location for building.  
If a SSL ID is passed, shuttle queries the SSL for the project's corresponding URL and uses the same method as a passed git URL to install.  
If a directory is passed, shuttle uses that directory as the root for a project build.

If you're already inside a project root, a simple `shuttle install` will suffice, building that project and installing the built file.

```bash title="Install shuttle using shuttle's id from the SSL"
shuttle install shuttle
```

```bash title="Install shuttle using it's upstream git url"
shuttle install https://github.com/eiedouno/shuttle
```

```bash title="Install shuttle using a local directory with it's source code"
shuttle install ./shuttle
```

The `--force`, `--quiet` and `--verbose` flags are implemented. The build commands progress bar will display unless `--quiet` is specified. Shuttle will ask if you want to override the file inside the output directory if it exists and if `--force` isn't specified. Shuttle will display project metadata if `--verbose` is specified.
