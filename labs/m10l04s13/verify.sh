#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
deploy = w.get('jobs', {}).get('deploy', {})
if_cond = str(deploy.get('if', ''))
has_if = bool(if_cond)
contains_main = 'main' in if_cond
print(f'has_if_condition={has_if}')
print(f'if_contains_main={contains_main}')
"

