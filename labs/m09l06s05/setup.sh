#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

BLOB=$(echo "Hello, plumbing!" | git hash-object -w --stdin)
TREE=$(printf "100644 blob %s\thello.txt\n" "$BLOB" | git mktree)
COMMIT=$(git commit-tree "$TREE" -m "Initial commit")
git update-ref refs/heads/main "$COMMIT"
git symbolic-ref HEAD refs/heads/main
export BLOB TREE COMMIT
