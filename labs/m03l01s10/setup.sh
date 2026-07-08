#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

# Создаём два bare-репозитория
git init -q --bare /tmp/origin.git
git init -q --bare /tmp/upstream.git

# Создаём рабочую директорию ученика
git init -q
echo "hello" > README.md
git add README.md
git commit -q -m "Initial commit"
