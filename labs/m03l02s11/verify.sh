#!/usr/bin/env bash
set -euo pipefail
git --git-dir=/tmp/origin.git log --pretty='%s' --reverse feature/payment

