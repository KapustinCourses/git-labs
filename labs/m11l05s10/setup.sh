#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
mkdir -p .github/workflows

# Подготавливаем reusable template
cat > .github/workflows/template.yml << 'TEOF'
name: CI Template
on:
  workflow_call:
    inputs:
      node-version:
        type: string
        default: '20'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Node ${{ inputs.node-version }}"
TEOF
