#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global protocol.file.allow always

# Создаём bare-репо библиотеки
LIB_BARE="$(mktemp -d)/lib.git"
git init -q --bare "$LIB_BARE"
LIB_TMP="$(mktemp -d)"
git clone -q "$LIB_BARE" "$LIB_TMP"
(cd "$LIB_TMP" && echo "lib content" > lib.txt && git add lib.txt && git commit -q -m "Initial lib" && git push -q origin main)

# Создаём основной проект с submodule
PROJ_TMP="$(mktemp -d)"
cd "$PROJ_TMP"
git init -q
echo "main app" > app.py
git add app.py
git commit -q -m "Initial commit"
git submodule add -q "$LIB_BARE" vendor/lib
git commit -q -m "Add lib submodule"

# Создаём bare-репо основного проекта
MAIN_BARE="$(mktemp -d)/main.git"
git init -q --bare "$MAIN_BARE"
git remote add origin "$MAIN_BARE"
git push -q origin main

export MAIN_BARE
