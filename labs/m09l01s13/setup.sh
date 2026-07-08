#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

TOPDIR="$(mktemp -d)"

# Создаём bare-репозиторий как имитацию origin
git init -q --bare "$TOPDIR/origin.git"

# Наполняем его содержимым через отдельный репо
( cd "$TOPDIR" && git init -q setup && cd setup && \
  git remote add origin "file://$TOPDIR/origin.git" && \
  mkdir -p services libs docs && \
  echo "console.log('api');" > services/api.js && \
  echo "module.exports = {};" > libs/utils.js && \
  echo "# Docs" > docs/README.md && \
  echo "# Monorepo" > README.md && \
  git add . && \
  git commit -q -m "Initial commit" && \
  git push -q origin main )

# Клонируем в work
git clone -q "$TOPDIR/origin.git" "$TOPDIR/work"
export TOPDIR
cd "$TOPDIR/work"
