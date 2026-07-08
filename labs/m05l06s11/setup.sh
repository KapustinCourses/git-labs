#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

# Создаём bare-репо ("сервер")
ORIGIN="$(mktemp -d)/origin.git"
git init -q --bare "$ORIGIN"

# Создаём рабочий репо и делаем initial push
git init -q
git remote add origin "file://$ORIGIN"

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "base" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q -u origin main

export GIT_AUTHOR_DATE="2024-01-01T10:01:00"
export GIT_COMMITTER_DATE="2024-01-01T10:01:00"
echo "feature" > feature.py
git add feature.py
git commit -q -m "Add feature"
git push -q origin main

# Имитируем: "коллега" пушит коммит прямо в origin, ПОСЛЕ нашего fetch
COLLEAGUE_REPO="$(mktemp -d)"
git clone -q "file://$ORIGIN" "$COLLEAGUE_REPO"
cd "$COLLEAGUE_REPO"
export GIT_AUTHOR_DATE="2024-01-01T10:02:00"
export GIT_COMMITTER_DATE="2024-01-01T10:02:00"
echo "colleague work" > colleague.py
git add colleague.py
git commit -q -m "Colleague: add work"
git push -q origin main

# Возвращаемся в наш рабочий репо — делаем amend (sha меняется, fetch не делали)
git commit --amend -q -m "Add feature (improved)"
