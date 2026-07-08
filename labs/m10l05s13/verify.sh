#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = w['jobs']['test']
steps = job.get('steps', [])
steps_count = len(steps)
if_steps = [s for s in steps if 'if' in s]
has_if = bool(if_steps)
if_main = any('main' in str(s.get('if', '')) for s in steps)
print(f'steps_count={steps_count}')
print(f'has_if_step={has_if}')
print(f'if_contains_main={if_main}')
"

