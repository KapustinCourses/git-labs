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

git switch -c feature
echo "exp1" > exp1.txt
git add exp1.txt
git commit -q -m "WIP experiment 1"

echo "exp2" > exp2.txt
git add exp2.txt
git commit -q -m "WIP experiment 2"

echo "real" > real.txt
git add real.txt
git commit -q -m "Add real feature"

echo "polish" >> real.txt
git add real.txt
git commit -q -m "Polish feature"

git switch main
