#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s'
git ls-tree --name-only HEAD

