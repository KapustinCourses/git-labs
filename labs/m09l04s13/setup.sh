#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

for i in 1 2 3 4 5 6 7 8; do
  echo "version $i content" > file.txt
  echo "extra data $i" > extra.txt
  git add file.txt extra.txt
  git commit -q -m "Commit $i"
done
