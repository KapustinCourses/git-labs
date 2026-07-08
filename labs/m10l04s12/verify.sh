#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
test_job = w['jobs']['test']
matrix_node = test_job.get('strategy', {}).get('matrix', {}).get('node', [])
steps = test_job.get('steps', [])
uses_setup = any('setup-node' in str(s.get('uses', '')) for s in steps)
print(f'matrix_node={matrix_node}')
print(f'uses_setup_node={uses_setup}')
"

