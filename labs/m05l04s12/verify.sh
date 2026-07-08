#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s'
git status --porcelain | wc -l | tr -d ' '

