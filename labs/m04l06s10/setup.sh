#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "# Project" > README.md
git add README.md
git commit -q -m "Initial commit"

echo "def main(): pass" > app.py
git add app.py
git commit -q -m "Add main logic"

# feature-ветка
git checkout -q -b feature/sidebar
echo "def sidebar(): pass" > sidebar.py
git add sidebar.py
git commit -q -m "Add sidebar"

# Merge обратно в main
git checkout -q main
git merge -q --no-ff feature/sidebar -m "Merge feature/sidebar into main"
