#!/usr/bin/env bash
set -euo pipefail
git ls-tree --name-only HEAD | LC_ALL=C sort
git log --pretty='%s' --reverse main

