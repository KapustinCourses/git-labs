#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml, sys
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
jobs = w.get('jobs', {})
print(','.join(sorted(jobs.keys())))
"

