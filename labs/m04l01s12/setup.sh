#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

echo "package main" > main.go
git add main.go
git commit -q -m "Initial commit"

echo "func loadConfig() {}" >> main.go
git add main.go
git commit -q -m "Add config loader"

cat >> main.go << 'EOF'

func parseConfig(data string) map[string]string {
    return nil
}
EOF
git add main.go
git commit -q -m "Add config parser module"

echo "func main() {}" >> main.go
git add main.go
git commit -q -m "Add main entrypoint"
