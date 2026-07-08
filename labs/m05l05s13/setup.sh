#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "base" > README.md
git add README.md
git commit -q -m "Initial commit"

# Создаём ветку feature/bad и добавляем «плохой» коммит
git checkout -q -b feature/bad

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "bad code" > bad.py
git add bad.py
git commit -q -m "Add bad feature"

# Вливаем feature/bad в main
git checkout -q main
export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
GIT_MERGE_AUTOEDIT=no git merge --no-ff feature/bad -m "Merge branch 'feature/bad'" >/dev/null 2>&1
