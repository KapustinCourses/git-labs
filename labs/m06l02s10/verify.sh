#!/usr/bin/env bash
set -euo pipefail
cat app.txt
git log --pretty='%s' --reverse feature

