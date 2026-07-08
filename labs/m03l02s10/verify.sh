#!/usr/bin/env bash
set -euo pipefail
git --git-dir=/tmp/origin.git branch | sed 's/^[* ] //' | sort

