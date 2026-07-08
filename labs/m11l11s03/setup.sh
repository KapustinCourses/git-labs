#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
mkdir -p .github/workflows

# Подготавливаем каркас из шага 1
cat > .github/workflows/release.yml << 'WYAML'
name: Release
on:
  push:
    branches: [main]
permissions: {}
jobs:
  placeholder:
    runs-on: ubuntu-latest
    steps:
      - run: echo "placeholder"
WYAML
cat > go.mod << 'GOEOF'
module example.com/myapp

go 1.24
GOEOF
cat > main.go << 'GOEOF'
package main
import "fmt"
func main() { fmt.Println("hello") }
GOEOF
