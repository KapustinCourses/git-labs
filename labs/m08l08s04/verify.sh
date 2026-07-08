#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' hotfix/csrf | awk 'NR==1'

