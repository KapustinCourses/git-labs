#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
if git switch feature 2>/dev/null; then
  echo "FAIL: switched unexpectedly"
else
  echo "blocked"
fi
