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
echo "step1" > step1.txt
git add step1.txt
git commit -q -m "WIP: start feature"

export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "step2" > step2.txt
git add step2.txt
git commit -q -m "WIP: continue feature"

export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
echo "step3" > step3.txt
git add step3.txt
git commit -q -m "WIP: finish feature"
