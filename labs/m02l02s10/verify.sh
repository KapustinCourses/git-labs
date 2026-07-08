#!/usr/bin/env bash
set -euo pipefail
cat /tmp/base.txt | xargs git log --pretty='%s' -n1

