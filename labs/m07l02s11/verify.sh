#!/usr/bin/env bash
set -euo pipefail
cat config.txt
git log --pretty='%s' --reverse main

