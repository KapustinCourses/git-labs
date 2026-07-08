#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
if git fsck --lost-found 2>&1 | grep -q "dangling commit"; then
  echo "found dangling"
fi
