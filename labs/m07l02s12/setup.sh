#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "mode=default" > settings.txt
git add settings.txt
git commit -q -m "Initial commit"

git switch -q -c feature
echo "lang=ru" > settings.txt
git add settings.txt
git commit -q -m "Add lang setting"

git switch -q main
echo "theme=dark" > settings.txt
git add settings.txt
git commit -q -m "Add theme setting"

git switch -q feature
git rebase main >/dev/null 2>&1 || true
