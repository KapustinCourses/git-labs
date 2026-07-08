#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git log --pretty='%s' v1.0..v1.1 -- CHANGELOG.md | wc -l | tr -d ' '
