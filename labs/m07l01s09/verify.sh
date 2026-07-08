#!/usr/bin/env bash
set -euo pipefail
git status --porcelain
git log --pretty='%s' --reverse main

