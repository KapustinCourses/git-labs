#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)

def check_cache(job_name):
    job = w['jobs'].get(job_name, {})
    steps = job.get('steps', [])
    for s in steps:
        if 'setup-go@v6' in str(s.get('uses','')):
            return s.get('with', {}).get('cache') is True
    return False

print(f'lint_setup_go_cache={check_cache(\"lint\")}')
print(f'test_setup_go_cache={check_cache(\"test\")}')
"

