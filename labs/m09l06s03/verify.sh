#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
TREE=$(printf "100644 blob %s\thello.txt\n" "$BLOB" | git mktree)
git ls-tree --name-only "$TREE"
