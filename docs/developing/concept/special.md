---
icon: lucide/folder-bookmark
---

# :lucide-folder-bookmark: Special Folders

Shuttle's special folders are both to simplify the build system whilst also providing organization to the project.

Shuttle currently has one special folder.

## :lucide-folder-code: `lib/texts`

In a simple summary, **the `lib/texts/` directory is where all of the multi-line text goes**.

This directory was created because the build system would be too slow and advanced if it had to take here-docs and other multi-line quirks into account. To simplify this, this directory was established as the "no edit" directory.

!!! warning "Any and all files inside this directory will not be modified when building shuttle."

!!! note "Remember: files in this directory still have to end in `.bash`"

```tree title="Directory tree of the lib/texts directory with a 'hello_world.bash' file"
.
├── lib
│   └── texts
│       └── hello_world.bash
├── project
└── src
    └── main.bash
```

Typically, files inside the the `lib/texts` directory are just a `printf` statement. You shouldn't use this directory for any sort of code because it won't be properly converted when building. Examples can be found inside shuttle's source code, files  
[`lib/texts/usage.bash`](https://github.com/eiedouno/shuttle/blob/main/lib/texts/usage.bash) (shuttle's help command) and  
[`lib/texts/template_start.bash`](https://github.com/eiedouno/shuttle/blob/main/lib/texts/template_start.bash) (shuttle's front entry point template).
