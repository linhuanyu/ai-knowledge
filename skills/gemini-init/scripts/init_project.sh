#!/bin/bash

# Setup .ai directory structure
mkdir -p .ai/skills

# Move and rename GEMINI.md if it exists
if [ -f GEMINI.md ]; then
    if [ ! -L GEMINI.md ]; then
        mv GEMINI.md .ai/global-rules.md
        echo "Moved GEMINI.md to .ai/global-rules.md"
    else
        echo "GEMINI.md is already a symlink, skipping move."
    fi
else
    if [ ! -f .ai/global-rules.md ]; then
        touch .ai/global-rules.md
        echo "Created .ai/global-rules.md"
    fi
fi

# Create symbolic link for GEMINI.md in root
ln -sf .ai/global-rules.md GEMINI.md
echo "Created symlink GEMINI.md -> .ai/global-rules.md"

# Create symbolic link for skills
ln -sf ~/.gemini/skills .ai/skills/global
echo "Created symlink .ai/skills/global -> ~/.gemini/skills"

# Update .gitignore
GITIGNORE=".gitignore"
if [ -f "$GITIGNORE" ]; then
    for entry in ".ai/tasks" ".gemini"; do
        if ! grep -q "^$entry" "$GITIGNORE"; then
            echo -e "\n$entry" >> "$GITIGNORE"
            echo "Added $entry to .gitignore"
        fi
    done
else
    echo -e ".ai/tasks\n.gemini" > "$GITIGNORE"
    echo "Created .gitignore with .ai/tasks and .gemini"
fi

echo "Project initialization completed with structured .ai/ directory and .gitignore updates."
