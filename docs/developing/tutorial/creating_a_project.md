---
icon: lucide/package-plus
---

# :lucide-package-plus: Building a new project

## :lucide-folder-plus: Creating the project

You'll start your learning by making a directory to store your shuttle project. Generally, projects are stored inside the `~/projects` directory, but can be anywhere on your file system.

Luckily, shuttle makes project creation incredibly easy. There are two entire commands dedicated to it! In this guide, we'll create a project using the `new` command inside shuttle.

??? note "Remember! Shuttle comes with a built-in help command!"

    Use `shuttle help <command>` for an easy refrence to what the command does as well as what arguments it takes.

```bash title="Create a new project using shuttle called 'project'"
shuttle new project
```

Replace 'project' with the name you're calling your project. We'll be assuming the name of the project is `project` for the rest of this guide. Congratulations! You've created a shuttle project! We're officially done here!

In all seriousness though, now you should see three new files: `project`, `shuttle.json` and `src/main.bash`.

```tree title="Directory tree of a new shuttle project"
.
├── project
├── shuttle.json
└── src
    └── main.bash
```

!!! note "Note! All shuttle script source files must always end in `.bash`"

The `project` file is your projects 'front' entry point, and it's where you call your script. The entry point of the literal code is inside the `src/main.bash` file. The function `main` doesn't need to exist, it's just the template. You are free to format your code however you like.

Only add code to the `project` file if you're looking to start your code via a custom entry environment. If you don't know, don't modify it.

### :lucide-file-braces: shuttle.json

`shuttle.json` is the project settings file. It is always called this. The default values are provided here for convenience. **It intentionally isn't needed**, though it allows shuttle to better understand and properly handle your project.

```json title="'shuttle.json' default values"
{
    "id": "user.project",
    "name": "project",
    "version": "0.1",
    "type": "script"
}
```

!!! note "This file is explained in-depth on it's [dedicated concept page](../concept/json_config.md)."

## :lucide-play: Running the project

You can run the project also, though there is one caveat. **You must always run uncompiled shuttle script source code from the root directory of the project.** This is because of how the source command resolves file location.

As mentioned above, just run the `project` file (the 'front' entry point) from your projects root. Remember, the file name is based on your project's name.

```bash title="Run a shuttle project called 'project'"
./project
```

It really isn't that hard folks, it's just glorified scripting.

## :lucide-package: Building the project

Building a project with shuttle is easy.

```bash title="Build a project in the current directory"
shuttle build
```

This builds the project that is inside the current directory. If you weren't inside a project directory, shuttle would error.

If you want to build a project that's in a different directory, you can specify the directory after `build`:

```bash title="Build a project in the directory 'project'"
shuttle build project
```

Simple enough, right? Like stated (and demonstrated), it's just glorified scripting.

The project build output location is inside the root directory of your project under the name `project.bash`.

!!! note "This concept is explained in-depth on it's [dedicated concept page](../concept/building.md)."
