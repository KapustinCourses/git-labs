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
echo "bug1" > bug1.txt
git add bug1.txt
git commit -q -m "Add bug 1"

export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "bug2" > bug2.txt
git add bug2.txt
git commit -q -m "Add bug 2"

export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
echo "bug3" > bug3.txt
git add bug3.txt
git commit -q -m "Add bug 3"
