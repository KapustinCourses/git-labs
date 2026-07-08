#!/usr/bin/env bash
set -euo pipefail
git branch | sed 's/^[* ] //' | LC_ALL=C sort
git log --pretty='%s' old-state | tail -1

