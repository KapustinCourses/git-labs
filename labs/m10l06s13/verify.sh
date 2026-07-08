#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = w['jobs']['test']
steps = job['steps']
checkout = any('checkout@v6' in str(s.get('uses', '')) for s in steps)
setup_node = any('setup-node@v6' in str(s.get('uses', '')) for s in steps)
npm_ci = any('npm ci' in str(s.get('run', '')) for s in steps)
print(f'steps_count={len(steps)}')
print(f'has_checkout={checkout}')
print(f'has_setup_node={setup_node}')
print(f'has_npm_ci={npm_ci}')
"

