#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git bisect reset >/dev/null 2>&1 || true
git bisect start >/dev/null 2>&1 || true
git bisect bad HEAD >/dev/null 2>&1 || true
git bisect good "$GOOD_SHA" >/dev/null 2>&1 || true
git bisect run sh ./test.sh >"$BISECT_LOG" 2>&1 || true
BAD_SHA=$(grep 'is the first bad commit' "$BISECT_LOG" | awk '{print $1}')
git bisect reset >/dev/null 2>&1 || true
git log --pretty='%s' -n1 "$BAD_SHA"
