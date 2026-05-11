---
name: linhuanyu-github-clone
description: Enforces using SSH format (git@github.com:linhuanyu/xxx.git) when cloning GitHub repositories for the user linhuanyu.
---

# GitHub Cloning for linhuanyu

When the user asks to clone a repository from GitHub, always use the SSH URL format instead of HTTPS.

## Workflow

1. Identify the repository name (e.g., `tongue-ai`).
2. Construct the SSH URL: `git@github.com:linhuanyu/<repo-name>.git`.
3. Use the global rule: all programs must be placed in a subdirectory of `~/program`.
4. Execute the clone command: `git clone git@github.com:linhuanyu/<repo-name>.git ~/program/<repo-name>`.

## Example

User: "clone tongue-ai"
Action: `git clone git@github.com:linhuanyu/tongue-ai.git ~/program/tongue-ai`
