#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global push.default simple
__REPO__="$(pwd)"

rm -rf /tmp/origin.git
git init -q --bare /tmp/origin.git

SETUP="$(mktemp -d)"
cd "$SETUP"
git init -q
git remote add origin file:///tmp/origin.git
echo "v1.0.0" > VERSION
git add VERSION
git commit -q -m "Initial release"
git push -q -u origin main

git clone -q file:///tmp/origin.git "$__REPO__"
