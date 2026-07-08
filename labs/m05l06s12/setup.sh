#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

# Создаём bare-репо ("сервер")
ORIGIN="$(mktemp -d)/origin.git"
git init -q --bare "$ORIGIN"

# Создаём рабочий репо
git init -q
git remote add origin "file://$ORIGIN"

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "base" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q -u origin main

# Создаём feature/auth от старого main
git checkout -q -b feature/auth
export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "auth code" > auth.py
git add auth.py
git commit -q -m "Add auth"
git push -q -u origin feature/auth

# На main добавляем новый коммит ("коллега")
git checkout -q main
export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "main update" > main_update.txt
git add main_update.txt
git commit -q -m "Update main"
git push -q origin main

# Возвращаемся на feature/auth и делаем rebase на новый main
git checkout -q feature/auth
git fetch -q origin main
export GIT_AUTHOR_DATE="2024-01-01T10:03:00"
export GIT_COMMITTER_DATE="2024-01-01T10:03:00"
git rebase -q origin/main

# Запоминаем путь к bare-репо
echo "$ORIGIN" > /tmp/origin_path.txt
