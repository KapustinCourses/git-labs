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
git switch -q -c feature1
echo "f1" > f1.txt
git add f1.txt
git commit -q -m "Feature1 work"
git switch -q main
git merge -q feature1 --no-ff -m "Merge feature1" > /dev/null
git switch -q -c feature2
echo "f2" > f2.txt
git add f2.txt
git commit -q -m "Feature2 work"
git switch -q main
git merge -q feature2 --no-ff -m "Merge feature2" > /dev/null
