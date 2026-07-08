#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "version=1.0" > app.txt
git add app.txt
git commit -q -m "Initial commit"

git switch -q -c feature
echo "version=2.0-feature" > app.txt
git add app.txt
git commit -q -m "Update app on feature"

git switch -q main
echo "version=2.0-main" > app.txt
git add app.txt
git commit -q -m "Update app on main"
