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

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "module A" > module_A.py
git add module_A.py
git commit -q -m "Add module A"

export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "module B" > module_B.py
git add module_B.py
git commit -q -m "Add module B"

export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
echo "module C" > module_C.py
git add module_C.py
git commit -q -m "Add module C"

export GIT_AUTHOR_DATE="2024-01-01T10:04:00"
export GIT_COMMITTER_DATE="2024-01-01T10:04:00"
echo "module D" > module_D.py
git add module_D.py
git commit -q -m "Add module D"

export GIT_AUTHOR_DATE="2024-01-01T10:05:00"
export GIT_COMMITTER_DATE="2024-01-01T10:05:00"
echo "module E" > module_E.py
git add module_E.py
git commit -q -m "Add module E"

# Случайный hard reset — теряем 5 коммитов
git reset -q --hard HEAD~5
