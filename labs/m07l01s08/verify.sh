#!/usr/bin/env bash
set -euo pipefail
git status --porcelain | grep '^UU' | wc -l | tr -d ' '

