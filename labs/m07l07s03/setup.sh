#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "Deprecated API v1" > deprecated-api.txt
echo "README" > README.md
git add .
git commit -q -m "Initial commit"

git switch -q -c feature/updates
echo "Deprecated API v1" > deprecated-api.txt
echo "NOTE: Use new API v2 at /api/v2/" >> deprecated-api.txt
git add deprecated-api.txt
git commit -q -m "Add migration note to deprecated API docs"

git switch -q main
git rm -q deprecated-api.txt
git commit -q -m "Remove deprecated API file"

git merge feature/updates >/dev/null 2>&1 || true
