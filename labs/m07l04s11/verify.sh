#!/usr/bin/env bash
set -euo pipefail
cat app.txt
git cat-file -p HEAD | grep '^parent' | wc -l | tr -d ' '

