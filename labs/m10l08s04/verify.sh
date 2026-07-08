#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
jobs = w.get('jobs', {})
jobs_sorted = ','.join(sorted(jobs.keys()))
test_job = jobs.get('test', {})
test_steps = test_job.get('steps', [])
has_go_test = any('go test' in str(s.get('run','')) for s in test_steps)
no_needs = 'needs' not in test_job
print(f'jobs={jobs_sorted}')
print(f'test_has_go_test={has_go_test}')
print(f'test_no_needs={no_needs}')
"

