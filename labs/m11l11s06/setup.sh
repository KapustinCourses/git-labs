#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
mkdir -p .github/workflows

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
  docker:
    needs: [test]
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: docker/build-push-action@v6
        with:
          push: false
  deploy:
    needs: [docker]
    environment: production
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::123456789012:role/r
          aws-region: us-east-1
      - run: echo "Deploying"
WYAML
