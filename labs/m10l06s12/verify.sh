#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = next(iter(w['jobs'].values()))
steps = job['steps']
checkout = any(s.get('uses', '') == 'actions/checkout@v6' for s in steps)
setup_node_step = next((s for s in steps if 'setup-node@v6' in str(s.get('uses', ''))), None)
setup_node = bool(setup_node_step)
node_ver = setup_node_step.get('with', {}).get('node-version', '') if setup_node_step else ''
print(f'uses_checkout_v6={checkout}')
print(f'uses_setup_node_v6={setup_node}')
print(f'node_version={node_ver}')
"

