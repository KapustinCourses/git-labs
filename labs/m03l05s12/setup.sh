#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "v1" > app.py && git add app.py && git commit -q -m "Initial release"
git tag -a v1.0.0 -m "Version 1.0.0"

echo "auth code" > auth.py && git add auth.py && git commit -q -m "Add user auth"
echo "bugfix" >> auth.py && git add auth.py && git commit -q -m "Fix login bug"
git tag -a v1.1.0 -m "Version 1.1.0"
