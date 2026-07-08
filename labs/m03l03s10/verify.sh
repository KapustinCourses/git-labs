#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse origin/main

