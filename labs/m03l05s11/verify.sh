#!/usr/bin/env bash
set -euo pipefail
echo "remote_tags: $(git --git-dir=/tmp/origin.git tag | paste -sd, -)"
echo "local_tags: $(git tag | paste -sd, -)"
