#!/usr/bin/env bash
set -euo pipefail
git reflog | grep -c "rebase" || echo "0"

