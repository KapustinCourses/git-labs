#!/usr/bin/env bash
set -euo pipefail
# Проверяем только видимые директории в work (исключаем .git)
find "$TOPDIR/work" -maxdepth 1 -mindepth 1 -type d -not -name ".git" -printf "%f\n" | LC_ALL=C sort

