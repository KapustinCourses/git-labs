#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Первый коммит — хороший код
cat > core.go << 'GOEOF'
package main

func Run() error {
    return nil
}
GOEOF
git add core.go
GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
git commit -q -m "Add core module"

# Плохой коммит — ломающий код
cat > core.go << 'GOEOF'
package main

func Run() error {
    panic("not implemented")
    return nil
}
GOEOF
git add core.go
GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
git commit -q -m "Refactor core"

BAD_SHA=$(git rev-parse HEAD)
export BAD_SHA

echo "# docs" >> README.md
git add README.md
GIT_AUTHOR_NAME="Charlie" GIT_AUTHOR_EMAIL="charlie@example.com" \
GIT_COMMITTER_NAME="Charlie" GIT_COMMITTER_EMAIL="charlie@example.com" \
git commit -q -m "Update docs"
