#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
on_val = w.get('on') or w.get(True)
push = on_val.get('push', {})
branches = push.get('branches', [])
paths = push.get('paths', [])
print(f'branches={branches}')
print(f'paths={paths}')
"

