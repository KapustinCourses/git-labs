#!/usr/bin/env bash
set -euo pipefail
git branch | sed 's/^[+* ] //' | LC_ALL=C sort

