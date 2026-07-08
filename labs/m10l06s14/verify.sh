#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml, os
action_path = '.github/actions/setup-node/action.yml'
action_exists = os.path.exists(action_path)
action_composite = False
if action_exists:
    with open(action_path) as f:
        a = yaml.safe_load(f)
    action_composite = a.get('runs', {}).get('using') == 'composite'

with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = next(iter(w['jobs'].values()))
steps = job.get('steps', [])
uses_local = any('.github/actions/setup-node' in str(s.get('uses', '')) for s in steps)

print(f'action_exists={action_exists}')
print(f'action_using_composite={action_composite}')
print(f'workflow_uses_local_action={uses_local}')
"

