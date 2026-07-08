#!/usr/bin/env bash
set -euo pipefail
git --git-dir="$REMOTE" log feature/payments --pretty='%s' --reverse

