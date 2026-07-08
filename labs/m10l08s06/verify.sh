#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
jobs = w.get('jobs', {})
jobs_sorted = ','.join(sorted(jobs.keys()))
build = jobs.get('build', {})
needs = build.get('needs', [])
if isinstance(needs, str):
    needs = [needs]
needs_str = ','.join(sorted(needs))
steps = build.get('steps', [])
has_go_build = any('go build' in str(s.get('run','')) for s in steps)
print(f'jobs={jobs_sorted}')
print(f'build_needs={needs_str}')
print(f'build_has_go_build={has_go_build}')
"

