#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "theme=default" > ui-config.txt
git add ui-config.txt
git commit -q -m "Initial commit"

git switch -q -c feature/ui
echo "theme=dark-mode" > ui-config.txt
git add ui-config.txt
git commit -q -m "Add dark mode theme"

git switch -q main
echo "theme=corporate-blue" > ui-config.txt
git add ui-config.txt
git commit -q -m "Set corporate theme"

git merge feature/ui >/dev/null 2>&1 || true
