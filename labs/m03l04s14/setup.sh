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

# Создаём initial commit
ORIG_SETUP="$(mktemp -d)"
cd "$ORIG_SETUP"
git init -q
git remote add origin file:///tmp/original.git
echo "app" > app.py
git add app.py
git commit -q -m "Initial commit"
git push -q -u origin main

# Форк получает тот же initial commit
FORK_SETUP="$(mktemp -d)"
cd "$FORK_SETUP"
git clone -q file:///tmp/original.git .
git remote set-url origin file:///tmp/fork.git
git push -q -u origin main

# В форке создаём feature/dark-mode
git switch -q -c feature/dark-mode
echo "body { background: #1e1e1e; }" > dark_mode.css
git add dark_mode.css
git commit -q -m "Add dark mode CSS"
git push -q -u origin feature/dark-mode

# Симулируем слияние PR в upstream (merge FF)
cd "$ORIG_SETUP"
git fetch -q file:///tmp/fork.git feature/dark-mode:feature/dark-mode
git merge -q --ff-only feature/dark-mode
git push -q origin main

# Ученик в своём клоне форка с веткой feature/dark-mode
git clone -q file:///tmp/fork.git "$__REPO__"
cd "$__REPO__"
git remote add upstream file:///tmp/original.git
git switch -q -c feature/dark-mode origin/feature/dark-mode
