#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
BLOB=$(echo "test content" | git hash-object -w --stdin)
echo "${BLOB:0:7}"
git cat-file -t "$BLOB"
