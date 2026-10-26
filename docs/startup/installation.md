---
icon: lucide/download
---

!!! Warning

    Shuttle is not responsible for any damage to your projects or your computer. While we review each project in the Shuttle Script Library, it is ultimately your job to review and ensure validity of each project.

## Distros

Because Shuttle is a shell script, **it should run the exact same on every distro** unless your shell is modified, which it isn't. However, it is important to note that shuttle requires other tools that might not be present on your system, and you have to install them yourself.

## Prerequisites

Shuttle requires the following to be present on your system and inside `$PATH` in order to function as intended.

* **[ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`)
* **[jq language tool](https://jqlang.org)** (`jq`)
* **[curl](https://github.com/curl/curl)** (`curl`)
* **[git CLI](https://git-scm.com/install/)** (`git`)

You can install these yourself with your package manager.

## Installation

### Downloading Shuttle

**Shuttle is only available officially through [the GitHub repository](https://github.com/eiedouno/shuttle).**

```bash
git clone https://github.com/eiedouno/shuttle
cd shuttle
```

### Installing Shuttle

Shuttle is a shell script, which doesn't need to be compiled. As such, you can run shuttle both compiled[^1] and from source.

To capitalize on this feature, you can use shuttle's source code to build a compiled version of itself and install it.

[^1]: "Compiled" in shuttle's terms refers to a shuttle project that has been compiled into one file using shuttle's "build" feature.

To install use the `install` command:

```bash
./shuttle install
```

After that's finished with no errors, you can delete the downloaded source code.

```bash
cd ..
rm -rf shuttle
```

---

## Uninstalling

Shuttle is intentionally easy to uninstall. If you've already deleted the source code, all you have to do is use shuttle's uninstall feature.

```bash
shuttle uninstall shuttle
```

### All modified directories

All of the directories shuttle touches are kept here for full cleanup if desired.

`$HOME/.cache/shuttle` (downloaded projects)  
`$HOME/.config/shuttle` (config)  
`$HOME/.local/bin` (installed shuttle projects)  
`/usr/local/bin` (computer-wide installed shuttle projects)
