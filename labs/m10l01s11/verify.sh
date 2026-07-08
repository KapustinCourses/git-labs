#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml, sys
try:
    with open('.github/workflows/ci.yml') as f:
        w = yaml.safe_load(f)
    on_key = w.get('on') or w.get(True)
    if not w.get('name'):
        print('fail: missing name')
        sys.exit(0)
    if not on_key and 'on' not in w and True not in w:
        print('fail: missing on')
        sys.exit(0)
    if not w.get('jobs'):
        print('fail: missing jobs')
        sys.exit(0)
    print('ok')
except Exception as e:
    print(f'fail: {e}')
"

