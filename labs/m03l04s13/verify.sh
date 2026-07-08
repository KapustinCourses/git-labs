#!/usr/bin/env bash
set -euo pipefail
git --git-dir=/tmp/fork.git branch | sed 's/^[* ] //' | sort

