#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

mc() {
  local author="$1" email="$2" msg="$3"
  GIT_AUTHOR_NAME="$author" GIT_AUTHOR_EMAIL="$email" \
  GIT_COMMITTER_NAME="$author" GIT_COMMITTER_EMAIL="$email" \
  git commit -q --allow-empty -m "$msg"
}

printf '#!/bin/sh\nexit 0\n' > run.sh
chmod +x run.sh
git add run.sh

mc "Alice"   "alice@example.com"   "Initial commit"
FIRST_SHA=$(git rev-parse HEAD)

mc "Bob"     "bob@example.com"     "Add API endpoint"
mc "Charlie" "charlie@example.com" "Add config parser"
mc "Alice"   "alice@example.com"   "Add unit tests"

# Сломавший коммит
printf '#!/bin/sh\nexit 1\n' > run.sh
GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
git add run.sh && git commit -q -m "Break run script"

mc "Alice"   "alice@example.com"   "Update README"
mc "Charlie" "charlie@example.com" "Fix typo"
mc "Bob"     "bob@example.com"     "Add logging"
mc "Alice"   "alice@example.com"   "Final cleanup"

export FIRST_SHA
BISECT_LOG=$(mktemp)
export BISECT_LOG
