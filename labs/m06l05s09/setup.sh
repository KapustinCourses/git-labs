#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "init" > README.md
git add README.md
git commit -q -m "Initial commit"

git switch -c feature/A
echo "a1" > a1.txt
git add a1.txt
git commit -q -m "Add A1"

echo "a2" > a2.txt
git add a2.txt
git commit -q -m "Add A2"

git switch -c feature/B
echo "b1" > b1.txt
git add b1.txt
git commit -q -m "Add B1"

echo "b2" > b2.txt
git add b2.txt
git commit -q -m "Add B2"

git switch main
echo "main-update" >> README.md
git add README.md
git commit -q -m "Add to main"
