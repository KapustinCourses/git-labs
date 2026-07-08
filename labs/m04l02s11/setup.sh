#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "# Project" > README.md
git add README.md
git commit -q -m "Initial commit"

# Создаём feature-ветку
git checkout -q -b feature/payment

echo "def process_payment(): pass" > payment.py
git add payment.py
git commit -q -m "Add payment module"

echo "def validate_payment(amount): return amount > 0" >> payment.py
git add payment.py
git commit -q -m "Fix payment validation"

# Возвращаемся в main и добавляем коммит
git checkout -q main
echo "## Updated docs" >> README.md
git add README.md
git commit -q -m "Update README"

# Переходим обратно на feature для работы ученика
git checkout -q feature/payment
