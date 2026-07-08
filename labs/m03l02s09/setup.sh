#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global push.default simple

# Очистка от предыдущих запусков
rm -rf /tmp/origin.git

# Создаём bare-репозиторий с initial commit
git init -q --bare /tmp/origin.git
SETUP="$(mktemp -d)"
cd "$SETUP"
git init -q
git remote add origin file:///tmp/origin.git
echo "# My project" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q -u origin main

# Возвращаемся в tmp, ученик будет работать в "work"
