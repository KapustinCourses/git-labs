#!/usr/bin/env bash
set -euo pipefail
git ls-tree --name-only HEAD | grep legacy.txt

