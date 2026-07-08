#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Alice пишет первую строку
GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_AUTHOR_DATE="2024-01-10T09:00:00" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
GIT_COMMITTER_DATE="2024-01-10T09:00:00" \
git commit -q --allow-empty -m "Project init"

echo "# Project Title" > README.md
git add README.md

GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_AUTHOR_DATE="2024-01-11T10:00:00" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
GIT_COMMITTER_DATE="2024-01-11T10:00:00" \
git commit -q -m "Add README title"

# Bob дописывает вторую строку
echo "Description by Bob" >> README.md
git add README.md

GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_AUTHOR_DATE="2024-01-12T11:00:00" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
GIT_COMMITTER_DATE="2024-01-12T11:00:00" \
git commit -q -m "Add README description"
