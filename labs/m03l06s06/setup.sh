#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global push.default simple
__REPO__="$(pwd)"

rm -rf /tmp/original.git /tmp/fork.git
git init -q --bare /tmp/original.git
git init -q --bare /tmp/fork.git

ORIG_SETUP="$(mktemp -d)"
cd "$ORIG_SETUP"
git init -q
git remote add origin file:///tmp/original.git
echo "# OpenSource Project" > README.md
git add README.md
git commit -q -m "Initial project"
git push -q -u origin main

FORK_SETUP="$(mktemp -d)"
cd "$FORK_SETUP"
git clone -q file:///tmp/original.git .
git remote set-url origin file:///tmp/fork.git
git push -q -u origin main
git switch -q -c feature/translate
printf '{"hello":"привет"}' > translations.json
git add translations.json
git commit -q -m "Add Russian translation"
git push -q -u origin feature/translate

# PR слит в upstream
cd "$ORIG_SETUP"
git fetch -q file:///tmp/fork.git feature/translate:_temp_translate
git merge -q --ff-only _temp_translate
git push -q origin main

# Состояние ученика: main синхронизирован с upstream, feature/translate ещё существует
cd "$__REPO__"
git clone -q file:///tmp/fork.git .
git remote add upstream file:///tmp/original.git
git switch -q -c feature/translate origin/feature/translate
git switch -q main
git fetch -q upstream
git merge -q --ff-only upstream/main
