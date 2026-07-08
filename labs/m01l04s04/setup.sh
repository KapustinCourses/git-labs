#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git init -q
cat > todo.py << 'PYEOF'
items = []

def add(item):
    items.append(item)
    print(f"Added: {item}")
PYEOF
echo "# Todo CLI" > README.md
git add README.md
git commit -q -m "Add README"
