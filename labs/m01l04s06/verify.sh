#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
mkdir -p __pycache__
touch __pycache__/todo.cpython-311.pyc
git status --porcelain --ignored
