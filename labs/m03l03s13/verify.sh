#!/usr/bin/env bash
set -euo pipefail
git branch -r | grep -v HEAD | sed 's|  origin/||' | sort

