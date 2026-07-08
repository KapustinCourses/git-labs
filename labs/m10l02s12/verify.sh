#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = next(iter(w['jobs'].values()))
steps = job['steps']
print(f'steps_count={len(steps)}')
first = steps[0]
print(f'first_uses={first.get(\"uses\", \"\")}')
"

