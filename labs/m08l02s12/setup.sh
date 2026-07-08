#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"

git init -q
echo "base" > README.md
git add README.md
git commit -q -m "Initial commit"

# Создаём ветку release от Initial commit
git switch -q -c release
git switch -q main

# Три коммита-фикса на main
echo "auth fix" > auth.py
git add auth.py
git commit -q -m "Fix auth"
echo "log fix" > logging.py
git add logging.py
git commit -q -m "Fix logging"
echo "timeout fix" > timeout.py
git add timeout.py
git commit -q -m "Fix timeout"

# Возвращаемся на release
git switch -q release
# BASE_SHA — sha коммита Initial commit на main (= то, что уже есть на release)
BASE_SHA=$(git log --pretty='%H' release | awk 'NR==1')
