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
echo "def run(): pass" > app.py
git add app.py
git commit -q -m "Add app logic"
echo "def test_run(): pass" > test_app.py
git add test_app.py
git commit -q -m "Add tests"
