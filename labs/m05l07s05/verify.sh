#!/usr/bin/env bash
set -euo pipefail
ORIGIN_PATH="$(cat /tmp/origin_path.txt)"
git --git-dir="$ORIGIN_PATH" log --pretty='%s' --reverse

