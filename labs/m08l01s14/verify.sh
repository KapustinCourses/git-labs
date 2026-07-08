#!/usr/bin/env bash
set -euo pipefail
git rev-parse --abbrev-ref HEAD
git status --porcelain | awk '{print $1, $2}'

