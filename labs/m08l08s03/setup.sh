#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "initial app" > app.py
git add app.py
git commit -q -m "Initial commit"
git switch -q -c feature
echo "initial payment" > payment.py
git add payment.py
git commit -q -m "Add payment module"
echo "WIP: validate amount" >> payment.py
git stash push -q -m "WIP: payment validation"
git switch -q main
git switch -q feature
