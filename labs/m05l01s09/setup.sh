#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "v1" > app.txt
git add app.txt
git commit -q -m "Initial commit"

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "v2" > app.txt
git add app.txt
git commit -q -m "Add feature A"

export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "v3" > app.txt
git add app.txt
git commit -q -m "Add feature B"

# reset --hard идёт в reflog как одна запись
git reset -q --hard HEAD~1

export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
echo "v3-fixed" > app.txt
git add app.txt
git commit -q -m "Add feature B fixed"
