#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "v1" > README.md
git add README.md
git commit -q -m "Commit 1"

echo "v2" > README.md
git add README.md
git commit -q -m "Commit 2"

echo "v3" > README.md
git add README.md
git commit -q -m "Commit 3"

git checkout -q -b feature
echo "feature" > feature.py
git add feature.py
git commit -q -m "Feature commit"

git checkout -q main
