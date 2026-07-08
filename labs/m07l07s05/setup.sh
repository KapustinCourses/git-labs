#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "indent=default" > code-style.txt
git add code-style.txt
git commit -q -m "Initial commit"

git switch -q -c feature/formatter
echo "indent=spaces-4" > code-style.txt
git add code-style.txt
git commit -q -m "Reformat: use 4 spaces indentation"

git switch -q main
echo "indent=tabs" > code-style.txt
git add code-style.txt
git commit -q -m "Use tabs for indentation"
