#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "initial" > README.md
git add README.md
git commit -q -m "Initial commit"

# Выполняем amend — в reflog появится запись "commit (amend)"
export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
GIT_EDITOR=true git commit --amend -q -m "Initial commit fixed"
