#!/usr/bin/env bash
set -euo pipefail
git stash list | wc -l | tr -d ' '

