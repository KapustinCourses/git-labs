#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse
git status --porcelain

