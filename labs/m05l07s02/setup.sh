#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

export GIT_AUTHOR_DATE="2024-01-01T10:00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00"
cat > config.yaml <<'EOF'
database:
  host: localhost
  port: 5432
EOF
git add config.yaml
git commit -q -m "Add config"

# Забытый файл лежит в рабочей директории, но не добавлен в коммит
echo "important setting" > forgotten.txt
