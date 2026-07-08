#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

BARE="$(mktemp -d)"
export BARE
git init -q --bare "$BARE"

git init -q
git remote add origin "file://$BARE"
echo "project auth" > auth.txt
git add auth.txt
git commit -q -m "Initial commit"
git push -q -u origin main

git switch -q -c "release/2024-Q1"
echo "auth=basic" > auth.txt
git add auth.txt
git commit -q -m "Add Q1 baseline"
git push -q -u origin "release/2024-Q1"

git switch -q main
echo "auth=oauth2-secure" > auth.txt
git add auth.txt
git commit -q -m "Fix authentication to OAuth2"
git push -q origin main

git rev-parse HEAD > /tmp/auth_fix_sha.txt
git switch -q "release/2024-Q1"
git cherry-pick "$(cat /tmp/auth_fix_sha.txt)" >/dev/null 2>&1 || true
