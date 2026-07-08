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

git switch -q -c feature

echo "v1" > payment.txt
git add payment.txt
git commit -q -m "WIP add payment"

echo "v2" > payment.txt
git add payment.txt
git commit -q -m "fix typo in payment"

echo "v3" > payment.txt
git add payment.txt
git commit -q -m "actually fix payment"
