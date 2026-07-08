#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git log --format='%H' -L 5,10:src/main.go | grep -E '^[0-9a-f]{40}$' | wc -l | tr -d ' '
