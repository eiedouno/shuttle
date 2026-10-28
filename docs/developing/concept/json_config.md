---
icon: lucide/file-braces
---

# :lucide-file-braces: `shuttle.json`

## :lucide-cog: Core

`shuttle.json` houses the projects metadata and other important snippets that shuttle uses to properly handle your project.

**It purposely isn't required to use shuttle's build system, but it's highly recommended.**

## :lucide-braces: Keys and values

|Key|Value type|Description|Default value
| ---- | ---- | ---- | ---- |
|`id`|string (`a-z`,`A-Z`,`0-9`,`_`,`.`)|Project internal identifier|`"$USER.<project name>"`
|`name`|string (`a-z`,`A-Z`,` `)|Project display name|`"<project name>"`
|`version`|string (`a-z`,`A-Z`,`0-9`,`_`,`.`)|The version shuttle uses to detect a newer version of a project|`"0.1"`
|`type`|`script`, `library`|Determines how shuttle will handle the project when working with it.|`"script"`
|`shell`|`sh`, `bash`, `zsh`|Determines shebang in the build output file|`"bash"`
|`deps`|array (of strings)|SSL IDs of project dependencies|*none*
|`raw_deps`|array (of strings)|Commands that must be present on the host in order to work correctly|*none*

## :lucide-shapes: Template

```json title="shuttle.json template"
{
    "id": "user.project",
    "name": "project",
    "version": "0.1",
    "type": "script",
    "shell": "bash",
    "deps": [
        "id",
        "id2"
    ],
    "raw_deps": [
        "bash",
        "realpath"
    ]
}
```
