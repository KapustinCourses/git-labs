#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse main
git --git-dir=/tmp/fork.git branch | sed 's/^[* ] //' | sort

