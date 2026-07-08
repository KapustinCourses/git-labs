#!/usr/bin/env bash
set -euo pipefail
git config -f .gitmodules submodule.vendor/lib.path
ls vendor/lib/

