#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
jobs = w.get('jobs', {})
jobs_list = ','.join(sorted(jobs.keys()))
build_needs = jobs.get('build', {}).get('needs', [])
if isinstance(build_needs, str):
    build_needs = [build_needs]
needs_str = ','.join(sorted(build_needs))
print(f'jobs={jobs_list}')
print(f'build_needs={needs_str}')
"

