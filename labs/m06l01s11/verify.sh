#!/usr/bin/env bash
set -euo pipefail
AFTER_SHA="$(git rev-parse HEAD)"
if [ "$AFTER_SHA" = "$BEFORE_SHA" ]; then
  echo "same"
else
  echo "changed"
fi

