#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse main
git rev-parse --abbrev-ref HEAD

