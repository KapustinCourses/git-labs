#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "hello" > README.md
git add README.md
git commit -q -m "Initial commit"

git switch -c feature
echo "feature content" > feature.txt
git add feature.txt
git commit -q -m "Add feature.txt"

git switch main
echo "updated" >> README.md
git add README.md
git commit -q -m "Update README"

git switch feature
