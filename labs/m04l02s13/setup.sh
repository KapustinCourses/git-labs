#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "# Changelog" > CHANGELOG.md
echo "" >> CHANGELOG.md
echo "## v1.0" >> CHANGELOG.md
echo "- Initial release" >> CHANGELOG.md
git add CHANGELOG.md
git commit -q -m "Release v1.0"
git tag v1.0

echo "def compute(): pass" > app.py
git add app.py
git commit -q -m "Add compute function"

echo "" >> CHANGELOG.md
echo "## v1.1" >> CHANGELOG.md
echo "- Added compute function" >> CHANGELOG.md
git add CHANGELOG.md
git commit -q -m "Update CHANGELOG for v1.1"
git tag v1.1
