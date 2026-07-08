#!/usr/bin/env bash
set -euo pipefail
if [ -f .env ]; then echo "exists"; else echo "missing"; fi
if [ -z "$(git ls-files .env)" ]; then echo "not tracked"; else echo "still tracked"; fi

