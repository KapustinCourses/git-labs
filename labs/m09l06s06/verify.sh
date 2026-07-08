#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
FSCK_OUT=$(git fsck --full 2>&1)
if echo "$FSCK_OUT" | grep -qE "^(error|missing)"; then
  echo "errors found"
else
  echo "ok"
fi
