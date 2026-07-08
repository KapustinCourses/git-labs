#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "base" > base.txt
git add base.txt
git commit -q -m "Base commit"
git switch -q -c feature
echo "feature" > feature.txt
git add feature.txt
git commit -q -m "Feature work"
git switch -q main
echo "main" > main.txt
git add main.txt
git commit -q -m "Main work"
