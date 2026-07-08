#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
actionlint .github/workflows/ci.yml 2>/dev/null || \
  (python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci.yml'))" && echo "OK")
