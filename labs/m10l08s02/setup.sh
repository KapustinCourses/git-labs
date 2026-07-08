#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

mkdir -p .github/workflows

# Эмулируем Go-проект
cat > go.mod << 'GOEOF'
module example.com/myapp

go 1.22
GOEOF

cat > main.go << 'GOEOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
GOEOF

cat > main_test.go << 'GOEOF'
package main

import "testing"

func TestMain(t *testing.T) {
    // basic test
}
GOEOF
