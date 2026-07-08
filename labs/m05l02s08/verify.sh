#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' -1
git ls-tree --name-only HEAD | sort

