#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

cat > core.py << 'PYEOF'
def init(): pass
def run(): pass
def stop(): pass
PYEOF
git add core.py
git commit -q -m "Add core module"
git tag v1.0

git rm -q core.py
git commit -q -m "Remove deprecated core module"
