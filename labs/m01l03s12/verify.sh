#!/usr/bin/env bash
set -euo pipefail
git ls-tree -r --name-only HEAD | LC_ALL=C sort

