#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "initial" > feature.py
git add feature.py
git commit -q -m "Initial commit"

# Создаём stash: добавляем изменение в feature.py
echo "feature work" >> feature.py
git stash push -q -m "WIP: feature work"

# Продвигаем main вперёд (имитируем новый коммит)
echo "other change" > other.py
git add other.py
git commit -q -m "Add other change"
