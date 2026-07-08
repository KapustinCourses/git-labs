#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "project" > README.md
git add README.md
git commit -q -m "Initial commit"

git switch -q -c feature1
echo "module 1" > module1.txt
git add module1.txt
git commit -q -m "Add module1"

git switch -q main
git switch -q -c feature2
echo "module 2" > module2.txt
git add module2.txt
git commit -q -m "Add module2"

git switch -q main
git switch -q -c feature3
echo "module 3" > module3.txt
git add module3.txt
git commit -q -m "Add module3"

git switch -q main
