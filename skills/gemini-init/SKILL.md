---
name: gemini-init
description: Automates project initialization with a structured .ai/ directory. Moves GEMINI.md to .ai/global-rules.md, creates a symlink in the root, links .ai/skills/ to global skills, and ensures .ai/tasks and .gemini are in .gitignore.
---

# Gemini Project Initialization

This skill standardizes the directory structure for AI instructions and local skills within a project.

## Workflow

When triggered, you should execute the following steps to organize the project's AI context:

1.  **Structure Setup**: Create a `.ai/` directory at the root.
2.  **Instruction Migration**: Move the root `GEMINI.md` to `.ai/global-rules.md`.
3.  **Root Link**: Create a symbolic link named `GEMINI.md` at the root pointing to `.ai/global-rules.md`.
4.  **Skills Link**: Create a symbolic link `.ai/skills/global` pointing to the user's global skills directory (`~/.gemini/skills`).
5.  **Git Protection**: Ensure `.ai/tasks` and `.gemini` are added to the `.gitignore` file to prevent sensitive or transient AI data from being committed.

## Execution

Run the bundled script to perform these actions:

```bash
bash [path-to-skill]/scripts/init_project.sh
```

## Benefits
- **Clean Root**: Keeps the project root cleaner.
- **Global Awareness**: Makes global skills discoverable locally.
- **Security & Hygiene**: Prevents AI-specific task logs and local overrides from leaking into version control.
