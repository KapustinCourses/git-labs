#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
mkdir -p .github/workflows

cat > Dockerfile << 'DEOF'
FROM golang:1.24 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/app .
FROM alpine:3.20
COPY --from=builder /bin/app /bin/app
ENTRYPOINT ["/bin/app"]
DEOF

cat > go.mod << 'GOEOF'
module example.com/myapp
go 1.24
GOEOF

cat > .github/workflows/release.yml << 'WYAML'
name: Release
on:
  push:
    branches: [main]
permissions: {}
jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    strategy:
      matrix:
        go: ['1.23', '1.24']
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-go@v6
        with:
          go-version: ${{ matrix.go }}
          cache: true
      - run: go test ./...
WYAML
