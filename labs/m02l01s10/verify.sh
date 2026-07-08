#!/usr/bin/env bash
set -euo pipefail
git branch | sed 's/^[* ] //' | sort

