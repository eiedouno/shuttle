---
icon: lucide/circle-question-mark
---

# :lucide-circle-question-mark: Developer FAQ

??? info "How would I source a file when compiled?"

    Only the `source` keyword is deleted. The `.` command still works (and is functionally the same to `source`). So **replace the `source` keyword with a period `.` if you want to keep the call after compiling**.

??? info "Why is my here-doc indented?"

    Don't use a here-doc. There is a [dedicated folder](tutorial/special.md) for multi-line text.
