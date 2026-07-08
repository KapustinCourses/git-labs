#!/usr/bin/env bash
set -euo pipefail
git --git-dir="$BARE" log --pretty='%s' --reverse "release/2024-Q1"

