---
icon: lucide/terminal
---

!!! Abstract "This guide assumes you already have shuttle installed. If you don't, see [installing](installation.md)."

## Installing Projects

!!! Warning

    Shuttle is not responsible for any damage to your projects or your computer. While we review each project in the Shuttle Script Library, it is ultimately your job to review and ensure validity of each project.

Shuttle is a package manager which installs projects from their upstream git repositories. So logically, the project must have a git repo for it to be downloadable by shuttle.

To install a project, simply type `shuttle install` followed by either the project's repository URL or the ID of the project inside the SSL[^1].

[^1]: The **Shuttle Script Library** is a list of projects and their URLs built into shuttle.

Examples:

```bash
shuttle install project
```

```bash
shuttle install https://github.com/user/project
```

## Uninstalling Projects

??? failure "Shuttle isn't limited to only shuttle projects!"

    Shuttle isn't limited to uninstalling only shuttle projects, **it deletes files from directories**. As such, any file that is inside `$HOME/.local/bin/` as a user and `/usr/local/bin/` as root are able to be deleted by shuttle.

    ??? info "Why?"

        Our reason for doing this is because we didn't want shuttle to have a database file which tracks all of it's installed projects. It would make shuttle more bloated as well as make many different possible edge-cases. The trade off is allowing shuttle to delete files in the directories they're install in. To mitigate this risk, we ask the user before deleting, overrideable with `--force`.

Uninstalling projects is just as easy. Simply type `shuttle uninstall` followed by the name of the project.

Examples:

```bash
shuttle uninstall project
```


