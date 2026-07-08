#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git gc --quiet
PACKS=$(git count-objects -v | grep '^packs:' | awk '{print $2}')
if [ "$PACKS" -gt 0 ]; then echo "compacted"; fi
