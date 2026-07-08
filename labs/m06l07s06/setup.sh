#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

export REMOTE="$(mktemp -d)"
git init -q --bare "$REMOTE"

git clone -q "$REMOTE" .
echo "init" > README.md
git add README.md
git commit -q -m "Initial commit"
git push -q origin main

git switch -c feature/payments

echo "form v1" > payment_form.txt
git add payment_form.txt
git commit -q -m "WIP payment form"

echo "validation" > payment_validation.txt
git add payment_validation.txt
git commit -q -m "Add payment validation"

echo "docs" > payment_docs.txt
git add payment_docs.txt
git commit -q -m "Add payment docs"

git push -q origin feature/payments

GIT_SEQUENCE_EDITOR='sed -i "1 s/^pick/reword/"' \
GIT_EDITOR='sh -c "echo \"Add payment form\" > \"$1\""' \
  git rebase -i HEAD~3 >/dev/null 2>&1
