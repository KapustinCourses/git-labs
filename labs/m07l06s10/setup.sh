#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "version=1.0" > version.txt
git add version.txt
git commit -q -m "Initial commit"

git switch -q -c release
echo "version=2.0-release" > version.txt
git add version.txt
git commit -q -m "Add release version"

git switch -q main
echo "version=2.1-hotfix" > version.txt
git add version.txt
git commit -q -m "Apply hotfix version"

git rev-parse HEAD > /tmp/hotfix_sha.txt
git switch -q release
git cherry-pick "$(cat /tmp/hotfix_sha.txt)" >/dev/null 2>&1 || true
