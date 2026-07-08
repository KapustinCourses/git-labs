#!/usr/bin/env bash
set -euo pipefail
MAIN_LOG=$(git log --pretty='%s' --reverse main | tr '\n' '|' | sed 's/|$//')
FEATURE_LOG=$(git log --pretty='%s' --reverse feature | tr '\n' '|' | sed 's/|$//')
echo "main: $MAIN_LOG"
echo "feature: $FEATURE_LOG"

