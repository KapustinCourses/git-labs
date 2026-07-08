#!/usr/bin/env bash
set -euo pipefail
git worktree list | wc -l | tr -d ' '

