#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "version 1" > app.txt
git add app.txt
git commit -q -m "Add version 1"

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "version 2" > app.txt
git add app.txt
git commit -q -m "Update to version 2"

export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "version 3" > app.txt
git add app.txt
git commit -q -m "Update to version 3"

export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
echo "version 4" > app.txt
git add app.txt
git commit -q -m "Update to version 4"
