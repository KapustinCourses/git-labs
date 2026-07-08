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

# Создаём историю: main + feature/payment
SETUP="$(mktemp -d)"
cd "$SETUP"
git init -q
git remote add origin file:///tmp/origin.git
echo "app" > app.py
git add app.py
git commit -q -m "Initial commit"
git push -q -u origin main
git switch -q -c feature/payment
echo "payment code" > payment.py
git add payment.py
git commit -q -m "Add feature"
git push -q -u origin feature/payment

# Клонируем для ученика (в рабочую директорию repo)
cd "$__REPO__"
git clone -q file:///tmp/origin.git .
git switch -q feature/payment
# Делаем amend — история расходится с origin
git commit -q --amend -m "Add feature (revised)"
