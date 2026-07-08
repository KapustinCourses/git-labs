#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
mkdir src

cat > src/main.go << 'GOEOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello")
    x := 1
    y := 2
    fmt.Println(x + y)
}
GOEOF
git add src/main.go
git commit -q -m "Add main file"

cat > src/main.go << 'GOEOF'
package main

import "fmt"

func main() {
    fmt.Println("World")
    a := 10
    b := 20
    fmt.Println(a * b)
}
GOEOF
git add src/main.go
git commit -q -m "Update main logic"
