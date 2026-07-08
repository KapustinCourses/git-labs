#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "old content" > legacy.txt
echo "readme" > README.md
git add .
git commit -q -m "Initial commit"

git switch -q -c feature
echo "old content" > legacy.txt
echo "new important line" >> legacy.txt
git add legacy.txt
git commit -q -m "Update legacy.txt in feature"

git switch -q main
git rm -q legacy.txt
git commit -q -m "Remove legacy.txt from main"

git merge feature >/dev/null 2>&1 || true
