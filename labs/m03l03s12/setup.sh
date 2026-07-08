#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main
git config --global push.default simple
__REPO__="$(pwd)"

rm -rf /tmp/origin.git
git init -q --bare /tmp/origin.git

# Создаём начальную историю
SETUP="$(mktemp -d)"
cd "$SETUP"
git init -q
git remote add origin file:///tmp/origin.git
echo "base" > base.py
git add base.py
git commit -q -m "Initial commit"
git push -q -u origin main

# Клонируем для ученика (в рабочую директорию repo)
cd "$__REPO__"
git clone -q file:///tmp/origin.git .

# Сервер получает свой коммит (через временный setup-репозиторий)
cd "$SETUP"
echo "server side" > server.py
git add server.py
git commit -q -m "Server commit"
git push -q origin main

# Ученик делает локальный коммит в своём клоне — истории расходятся
cd "$__REPO__"
echo "local side" > local.py
git add local.py
git commit -q -m "Local commit"
