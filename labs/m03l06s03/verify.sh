#!/usr/bin/env bash
set -euo pipefail
git log --pretty='%s' --reverse feature/translate
# Нормализуем завершающий перевод строки: nano/echo дают \n, printf/echo -n — нет.
# $(...) срезает все хвостовые \n, printf добавляет ровно один → код стабилен.
printf '%s\n' "$(cat translations.json)"

