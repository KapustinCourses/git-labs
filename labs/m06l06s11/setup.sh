#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

REMOTE="$(mktemp -d)"
git init -q --bare "$REMOTE"

git clone -q "$REMOTE" .
echo "env=base" > config.txt
git add config.txt
git commit -q -m "Initial commit"
git push -q origin main

echo "env=staging" > config.txt
git add config.txt
git commit -q -m "Local config"

SERVER_CONF="$(mktemp -d)"
git clone -q "$REMOTE" "$SERVER_CONF"
cd "$SERVER_CONF"
echo "env=production" > config.txt
git add config.txt
git commit -q -m "Server config"
git push -q origin main
