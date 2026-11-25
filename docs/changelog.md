---
icon: lucide/scroll-text
---

# :lucide-scroll-text: Changelog

## :lucide-replace: Version 0.1.3a

!!! example inline end "[In Development](https://github.com/eiedouno/shuttle/tree/dev)"

Dependency support update

**Added:**  
:lucide-circle-plus: URL-specified dependency support (no longer relies on existence inside SSL)

**Fixed:**  
:lucide-pencil-sparkles: Make version ID include the "alpha" identifier

**Removed:**  
:lucide-trash: Remove unnecessary debugging pauses inside `check_deps()`


## :lucide-package-check: [Version 0.1.2a](https://github.com/eiedouno/shuttle/tree/4ba3084aa19e98f1bdf975e97f5bb66ebf2320e3)

!!! success inline end "[Latest](https://github.com/eiedouno/shuttle)"

Shuttle source call fix

**Fixed:**  
:lucide-pencil-sparkles: Source calls don't redact all source keyword instances, only the call

## :lucide-package: [Version 0.1.1a](https://github.com/eiedouno/shuttle/tree/a39b0091e4712e063e74da540874b55c72d8e644)

General optimizations and QOL updates

**Added:**  
:lucide-circle-plus: Handle for empty library for `remove` command.  
:lucide-circle-plus: Dependency checks are now a part of the progress bar.  
:lucide-circle-plus: Added check for `$HOME/.local/bin` when installing (mkdir if it doesn't exist)  

**Fixed:**  
:lucide-pencil-sparkles: Parameter handling for the `run` command's passed arguments.  
:lucide-pencil-sparkles: Build files are now loaded into memory before working with them.  
:lucide-pencil-sparkles: Build output file is now only opened once for read/write during the compilation process, instead of once per line.  
:lucide-pencil-sparkles: Verbose text for `build` command now outputs to `STDERR`.  
:lucide-pencil-sparkles: `lib/texts` files are no longer read line-by-line in the compilation process.  
:lucide-pencil-sparkles: fixed `add` command's destination duplication  

## :lucide-package: [Version 0.1a](https://github.com/eiedouno/shuttle/tree/686b0b06ce58680feab974a9bfc826697d9b268a)

Shuttle's first official rewrite and first working version

**Added:**  
:lucide-circle-plus: Commands: add, remove, new, init, build, install, uninstall
