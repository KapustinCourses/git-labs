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
git switch -q -c feature
echo "login" > login.txt
git add login.txt
git commit -q -m "Add login"
echo "logout" > logout.txt
git add logout.txt
git commit -q -m "Add logout"
echo "auth" > auth.txt
git add auth.txt
git commit -q -m "Add auth check"
git switch -q main
echo "update" >> README.md
git add README.md
git commit -q -m "Main update"
