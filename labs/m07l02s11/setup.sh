#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "env=development" > config.txt
git add config.txt
git commit -q -m "Initial commit"

git switch -q -c feature
echo "env=staging" > config.txt
git add config.txt
git commit -q -m "Update config on feature"

git switch -q main
echo "env=production" > config.txt
git add config.txt
git commit -q -m "Update config on main"

git merge feature >/dev/null 2>&1 || true
