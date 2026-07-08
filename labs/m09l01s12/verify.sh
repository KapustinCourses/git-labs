#!/usr/bin/env bash
set -euo pipefail
cat .github/CODEOWNERS
git ls-files | LC_ALL=C sort

