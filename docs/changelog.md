---
icon: lucide/scroll-text
---

# :lucide-scroll-text: Changelog

!!! example inline end "[In Development](https://github.com/eiedouno/shuttle/tree/dev)"

## :lucide-git-pull-request-create-arrow: Version 0.1.1a

General optimizations and QOL updates

**Added:**  
:lucide-circle-plus: Handle for empty library for `remove` command.  
:lucide-circle-plus: Dependency checks are now a part of the progress bar.  

**Changed:**  
:lucide-pencil-sparkles: Parameter handling for the `run` command's passed arguments.  
:lucide-pencil-sparkles: Build files are now loaded into memory before working with them.  
:lucide-pencil-sparkles: Build output file is now only opened once for read/write during the compilation process, instead of once per line.  
:lucide-pencil-sparkles: Verbose text for `build` command now outputs to `STDERR`.  
:lucide-pencil-sparkles: `lib/texts` files are no longer read line-by-line in the compilation process.  

!!! info inline end "Latest"

## :lucide-package-check: Version 0.1a

Shuttle's first official rewrite and first working version

**Added:**  
:lucide-circle-plus: Commands: add, remove, new, init, build, install, uninstall
