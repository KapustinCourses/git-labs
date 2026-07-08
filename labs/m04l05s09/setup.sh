#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Commit 1: хороший
printf '#!/bin/sh\nexit 0\n' > check.sh
chmod +x check.sh
git add check.sh
git commit -q -m "Initial setup"
FIRST_SHA=$(git rev-parse HEAD)

# Commit 2: первый плохой
printf '#!/bin/sh\nexit 1\n' > check.sh
git add check.sh
git commit -q -m "Break check script"

# Commits 3–5: плохие
for i in 3 4 5; do
  echo "# step $i" >> check.sh
  git add check.sh
  git commit -q -m "Feature $i"
done

export FIRST_SHA
BISECT_LOG=$(mktemp)
export BISECT_LOG
