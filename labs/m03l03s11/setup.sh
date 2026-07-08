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

# Коллега пушит свой коммит (через временный setup-репозиторий)
cd "$SETUP"
echo "colleague work" > colleague.py
git add colleague.py
git commit -q -m "Colleague work"
git push -q origin main

# Ученик делает свой коммит в своём клоне (не зная о коллеге)
cd "$__REPO__"
echo "my work" > mywork.py
git add mywork.py
git commit -q -m "My work"
