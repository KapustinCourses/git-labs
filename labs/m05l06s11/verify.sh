#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
PUSH_OUT=$(git push --force-with-lease origin main 2>&1 || true)
echo "$PUSH_OUT" | grep -qiE "rejected|stale|error|non-fast-forward" && echo "rejected" || echo "ok"
