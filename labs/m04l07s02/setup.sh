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

mc "Alice"   "alice@example.com"   "Initial commit"
mc "Alice"   "alice@example.com"   "Add authentication"
mc "Bob"     "bob@example.com"     "Add API endpoint"
mc "Charlie" "charlie@example.com" "Optimize database query"
mc "Alice"   "alice@example.com"   "Add unit tests"
mc "Bob"     "bob@example.com"     "Add input validation"
mc "Charlie" "charlie@example.com" "Add config parser"
mc "Alice"   "alice@example.com"   "Update run script"
mc "Bob"     "bob@example.com"     "Fix typo in README"
mc "Alice"   "alice@example.com"   "Refactor core module"
mc "Bob"     "bob@example.com"     "Add logging"
