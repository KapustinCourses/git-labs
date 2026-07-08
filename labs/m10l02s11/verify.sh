#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml, sys
try:
    with open('.github/workflows/ci.yml') as f:
        w = yaml.safe_load(f)
    if not w.get('name'):
        print('fail: missing name'); sys.exit(0)
    on_val = w.get('on') or w.get(True)
    if on_val is None and 'on' not in w and True not in w:
        print('fail: missing on'); sys.exit(0)
    jobs = w.get('jobs', {})
    if not jobs:
        print('fail: missing jobs'); sys.exit(0)
    first_job = next(iter(jobs.values()))
    if not first_job.get('runs-on'):
        print('fail: missing runs-on'); sys.exit(0)
    if not first_job.get('steps'):
        print('fail: missing steps'); sys.exit(0)
    print('ok')
except Exception as e:
    print(f'fail: {e}')
"

