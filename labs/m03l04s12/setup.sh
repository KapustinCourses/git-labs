#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global push.default simple
__REPO__="$(pwd)"

rm -rf /tmp/original.git /tmp/fork.git
git init -q --bare /tmp/original.git
git init -q --bare /tmp/fork.git

# Создаём начальную историю в original
ORIG_SETUP="$(mktemp -d)"
cd "$ORIG_SETUP"
git init -q
git remote add origin file:///tmp/original.git
echo "docs" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q -u origin main

# Форк получает тот же initial commit
FORK_SETUP="$(mktemp -d)"
cd "$FORK_SETUP"
git clone -q file:///tmp/original.git .
git remote set-url origin file:///tmp/fork.git
git push -q -u origin main

# В original появляется новый коммит
cd "$ORIG_SETUP"
echo "updated" >> README.md
git add README.md
git commit -q -m "Update docs"
git push -q origin main

# Ученик клонирует fork (без нового коммита из original)
git clone -q file:///tmp/fork.git "$__REPO__"
