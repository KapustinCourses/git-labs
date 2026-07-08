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
echo "good code" > app.py
git add app.py
git commit -q -m "Initial commit"
git push -q -u origin main

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "buggy payment" >> app.py
git add app.py
git commit -q -m "Add payment bug"
git push -q origin main

echo "$ORIGIN" > /tmp/origin_path.txt
