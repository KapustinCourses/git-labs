#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Старые коммиты — всегда более года назад (даты заданы относительно текущего
# момента, чтобы практикум оставался корректным в любой день, а не только спустя
# год после фиксированной даты).
OLD_1=$(date -u -d "400 days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -u -v-400d +%Y-%m-%dT%H:%M:%S)
OLD_2=$(date -u -d "395 days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -u -v-395d +%Y-%m-%dT%H:%M:%S)

GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_AUTHOR_DATE="$OLD_1" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
GIT_COMMITTER_DATE="$OLD_1" \
git commit -q --allow-empty -m "Initial project setup"

GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_AUTHOR_DATE="$OLD_2" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
GIT_COMMITTER_DATE="$OLD_2" \
git commit -q --allow-empty -m "Add database schema"

# Свежие коммиты (14 и 3 дня назад)
TWO_WEEKS_AGO=$(date -u -d "14 days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -u -v-14d +%Y-%m-%dT%H:%M:%S)
ONE_WEEK_AGO=$(date -u -d "7 days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -u -v-7d +%Y-%m-%dT%H:%M:%S)
THREE_DAYS_AGO=$(date -u -d "3 days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || date -u -v-3d +%Y-%m-%dT%H:%M:%S)

GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_AUTHOR_DATE="$TWO_WEEKS_AGO" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
GIT_COMMITTER_DATE="$TWO_WEEKS_AGO" \
git commit -q --allow-empty -m "Add login page"

GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_AUTHOR_DATE="$ONE_WEEK_AGO" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
GIT_COMMITTER_DATE="$ONE_WEEK_AGO" \
git commit -q --allow-empty -m "Update README"

GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_AUTHOR_DATE="$THREE_DAYS_AGO" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
GIT_COMMITTER_DATE="$THREE_DAYS_AGO" \
git commit -q --allow-empty -m "Fix auth bug"
