#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "hello" > README.md
git add README.md
git commit -q -m "Initial commit"

# release ветка
git checkout -q -b release
echo "release notes" > RELEASE.md
git add RELEASE.md
git commit -q -m "Prepare release"

# main ветка с новым коммитом
git checkout -q main
echo "core feature" > core.py
git add core.py
git commit -q -m "Add main feature"

# feature ветка с двумя уникальными коммитами
git checkout -q -b feature main~1
echo "def widget(): pass" > widget.py
git add widget.py
git commit -q -m "Add new widget"

echo "def widget(): return True" > widget.py
git add widget.py
git commit -q -m "Fix widget bug"
