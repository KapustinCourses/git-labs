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

echo "db_host=localhost" > config.yaml
git add config.yaml
git commit -q -m "Add config file"

echo "def feature_a(): pass" > feature_a.py
git add feature_a.py
git commit -q -m "Add feature A"

# Имитируем «несчастный» сброс
git reset --hard HEAD~2 -q
