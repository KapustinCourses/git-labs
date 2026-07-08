#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "version 1" > app.txt
git add app.txt
git commit -q -m "Initial version"
git switch -q -c feature/header
echo "Welcome" > header.txt
git add header.txt
git commit -q -m "Add header"
git switch -q main
git merge -q feature/header > /dev/null
git branch -d -q feature/header > /dev/null
echo "version 2" > app.txt
git add app.txt
git commit -q -m "Bump version to 2"
git switch -q -c feature/footer HEAD~1
echo "Bye" > footer.txt
git add footer.txt
git commit -q -m "Add footer"
git switch -q main
