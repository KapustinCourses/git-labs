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

git switch -q -c release
echo "Release 1.0" > release-notes.txt
git add release-notes.txt
git commit -q -m "Add release notes"

git switch -q main
echo "bugfix content" > hotfix.txt
git add hotfix.txt
git commit -q -m "Fix critical bug"

git rev-parse HEAD > /tmp/fix_sha.txt
git switch -q release
