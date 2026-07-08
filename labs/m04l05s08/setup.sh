#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Коммиты 1–5: хорошие (каждый коммит должен быть уникальным, иначе
# "nothing to commit" обрывает setup при set -e)
for i in 1 2 3 4 5; do
  printf '#!/bin/sh\nexit 0\n' > test.sh
  echo "# feature $i" >> test.sh
  chmod +x test.sh
  git add test.sh
  git commit -q -m "Feature $i"
done
GOOD_SHA=$(git rev-parse HEAD~4)

# Коммит 6: первый плохой
printf '#!/bin/sh\nexit 1\n' > test.sh
chmod +x test.sh
git add test.sh
git commit -q -m "Introduce bug"

# Коммиты 7–9: плохие
for i in 7 8 9; do
  printf '#!/bin/sh\nexit 1\n' > test.sh
  echo "# step $i" >> test.sh
  git add test.sh
  git commit -q -m "Feature $i"
done

export GOOD_SHA
BISECT_LOG=$(mktemp)
export BISECT_LOG
