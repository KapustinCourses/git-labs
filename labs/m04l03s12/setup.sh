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

git checkout -q -b feature/auth
echo "def authenticate(): pass" > auth.py
git add auth.py
git commit -q -m "Add auth module"

git checkout -q main
git merge -q --no-ff feature/auth -m "Merge feature/auth into main"
