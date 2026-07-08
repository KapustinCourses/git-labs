#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
echo "Login HTML" > login.html
echo "Login JS"   > login.js
git add login.html login.js
git commit -q -m "Add login"

# login.css забыт — он в рабочей директории, но не в коммите
echo "Login CSS" > login.css
