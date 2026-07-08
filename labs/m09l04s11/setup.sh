#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "# App" > README.md
echo "console.log('app');" > app.js
echo '{"port":3000}' > config.json
git add README.md app.js config.json
git commit -q -m "Initial commit"

# Добавляем новый файл в индекс без коммита
echo "// new feature" > new-feature.js
git add new-feature.js
