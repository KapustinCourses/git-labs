#!/usr/bin/env bash
set -euo pipefail
cat app.go
git log --pretty='%s' --reverse

