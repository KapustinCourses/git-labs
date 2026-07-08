#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "hello" > README.md
git add README.md
git commit -q -m "Initial commit"

# Устанавливаем хук, который всегда отказывает
cat > .git/hooks/pre-commit <<'HOOK'
echo "Hook: commit rejected"
exit 1
HOOK
chmod +x .git/hooks/pre-commit

echo "fix" > fix.py
git add fix.py
