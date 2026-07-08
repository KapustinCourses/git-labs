#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "v1" > README.md
git add README.md
git commit -q -m "Version 1"

echo "v2" > README.md
git add README.md
git commit -q -m "Version 2"

echo "v3" > README.md
git add README.md
git commit -q -m "Version 3"

echo "v4" > README.md
git add README.md
git commit -q -m "Version 4"
