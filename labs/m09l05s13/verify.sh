#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
BLOB1=$(echo "Hello!" | git hash-object -w --stdin)
BLOB2=$(echo "World!" | git hash-object -w --stdin)
TREE=$(printf "100644 blob %s\thello.txt\n100644 blob %s\tworld.txt\n" "$BLOB1" "$BLOB2" | git mktree)
git ls-tree "$TREE" | awk '{print $4}' | LC_ALL=C sort
