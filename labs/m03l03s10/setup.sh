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

# Создаём начальную историю на origin
SETUP="$(mktemp -d)"
cd "$SETUP"
git init -q
git remote add origin file:///tmp/origin.git
echo "app" > app.py
git add app.py
git commit -q -m "Initial commit"
git push -q -u origin main

# Клонируем — у ученика только Initial commit
git clone -q file:///tmp/origin.git "$__REPO__"

# Добавляем коммит на сервер ПОСЛЕ клонирования
cd "$SETUP"
echo "server_host=localhost" > server.cfg
git add server.cfg
git commit -q -m "Add server config"
git push -q origin main

# Возвращаемся в рабочую директорию ученика
