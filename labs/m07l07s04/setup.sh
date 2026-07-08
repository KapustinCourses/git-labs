#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "payment system v1" > payments.txt
git add payments.txt
git commit -q -m "Initial commit"

git switch -q -c feature/payments
echo "gateway=stripe" > payments.txt
git add payments.txt
git commit -q -m "Add payment config"

echo "currency=USD" >> payments.txt
git add payments.txt
git commit -q -m "Add currency setting"

echo "max_amount=10000" >> payments.txt
git add payments.txt
git commit -q -m "Add payment limits"

git switch -q main
echo "gateway=paypal" > payments.txt
git add payments.txt
git commit -q -m "Switch to paypal gateway"

git switch -q feature/payments
git rebase main >/dev/null 2>&1 || true
