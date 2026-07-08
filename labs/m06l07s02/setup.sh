#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q
echo "init" > README.md
git add README.md
git commit -q -m "Initial commit"

git switch -c feature/payments

echo "form v1" > payment_form.txt
git add payment_form.txt
git commit -q -m "WIP add payment form"

echo "validation" > payment_validation.txt
git add payment_validation.txt
git commit -q -m "Add payment validation"

echo "form v2" > payment_form.txt
git add payment_form.txt
git commit -q -m "fix typo in form"

echo "tests" > payment_tests.txt
git add payment_tests.txt
git commit -q -m "WIP payment tests"

echo "validation v2" > payment_validation.txt
git add payment_validation.txt
git commit -q -m "fixup! Add payment validation"

echo "docs" > payment_docs.txt
git add payment_docs.txt
git commit -q -m "Add payment docs"

echo "form v3" > payment_form.txt
git add payment_form.txt
git commit -q -m "fixup! WIP add payment form"

git switch main
