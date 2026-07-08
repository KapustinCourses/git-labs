#!/usr/bin/env bash
set -euo pipefail
cat settings.txt
git log --pretty='%s' --reverse feature

