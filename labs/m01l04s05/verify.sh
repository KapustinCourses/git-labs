#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse
git ls-files | LC_ALL=C sort

