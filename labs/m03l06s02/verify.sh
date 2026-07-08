#!/usr/bin/env bash
set -euo pipefail
cd work 2>/dev/null || true
git remote -v | sort

