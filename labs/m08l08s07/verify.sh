#!/usr/bin/env bash
set -euo pipefail
git rev-parse --abbrev-ref HEAD
git stash list | wc -l | tr -d ' '

