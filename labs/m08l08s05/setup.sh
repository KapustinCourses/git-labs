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

# Создаём release ветку от Initial commit
git switch -q -c release/2024-Q1
git switch -q main

# Создаём feature ветку
git switch -q -c feature
echo "payment code" > payment.py
git add payment.py
git commit -q -m "Add payment"
git switch -q main

# Создаём hotfix worktree и делаем коммит
git worktree add -q -b hotfix/csrf ../hotfix-wt main
(cd ../hotfix-wt && echo "csrf fix" > csrf_fix.py && git add csrf_fix.py && git commit -q -m "Fix CSRF vulnerability")

# Возвращаемся в основную директорию на feature (как было до)
git switch -q feature
