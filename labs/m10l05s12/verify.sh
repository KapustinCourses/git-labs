#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
workflow_env = bool(w.get('env'))
job = next(iter(w.get('jobs', {}).values()), {})
job_env = bool(job.get('env'))
steps = job.get('steps', [])
step_env = any(s.get('env') for s in steps)
print(f'workflow_env={workflow_env}')
print(f'job_env={job_env}')
print(f'step_env={step_env}')
"

