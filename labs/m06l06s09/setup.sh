#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

REMOTE="$(mktemp -d)"
git init -q --bare "$REMOTE"

git clone -q "$REMOTE" .
echo "init" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q origin main

echo "local" > local.txt
git add local.txt
git commit -q -m "Local work"

SERVER_WORK="$(mktemp -d)"
git clone -q "$REMOTE" "$SERVER_WORK"
cd "$SERVER_WORK"
echo "server" > server.txt
git add server.txt
git commit -q -m "Server update"
git push -q origin main
