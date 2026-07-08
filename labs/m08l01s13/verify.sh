#!/usr/bin/env bash
set -euo pipefail
# Количество файлов в рабочей директории (без .git)
find . -maxdepth 1 -type f | wc -l | tr -d ' '
# Количество записей в stash
git stash list | wc -l | tr -d ' '

