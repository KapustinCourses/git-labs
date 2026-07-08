#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git init -q
echo "def main(): pass" > main.py
echo "def helper(): pass" > utils.py
git add main.py utils.py
git commit -q -m "Initial commit"
echo "print('hello')" >> main.py
echo "def extra(): pass" >> utils.py
