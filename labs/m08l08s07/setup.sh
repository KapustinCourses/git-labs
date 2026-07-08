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

# Создаём ветки
git switch -q -c release/2024-Q1
git switch -q main
git switch -q -c feature
echo "payment code" > payment.py
git add payment.py
git commit -q -m "Add payment"
echo "WIP: validate amount" >> payment.py
git stash push -q -m "WIP: payment validation"

# Переключаемся на release как "текущее состояние"
git switch -q release/2024-Q1
