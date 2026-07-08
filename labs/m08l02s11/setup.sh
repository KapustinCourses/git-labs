#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "base" > README.md
git add README.md
git commit -q -m "Initial commit"

# Создаём ветку release от Initial commit
git switch -q -c release

# На main добавляем фикс
git switch -q main
echo "csrf fix" > csrf.py
git add csrf.py
git commit -q -m "Fix CSRF"

# Возвращаемся на release (без фикса)
git switch -q release
