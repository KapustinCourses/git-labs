#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/lint-workflows.yml') as f:
    w = yaml.safe_load(f)
on_val = w.get('on') or w.get(True)
if isinstance(on_val, str):
    has_pr = on_val == 'pull_request'
elif isinstance(on_val, list):
    has_pr = 'pull_request' in on_val
elif isinstance(on_val, dict):
    has_pr = 'pull_request' in on_val
else:
    has_pr = False
jobs = w.get('jobs', {})
all_steps = []
for job in jobs.values():
    all_steps.extend(job.get('steps', []))
uses_actionlint = any('action-actionlint' in str(s.get('uses', '')) or 'actionlint-action' in str(s.get('uses', '')) for s in all_steps)
print(f'has_pr_trigger={has_pr}')
print(f'uses_actionlint_action={uses_actionlint}')
"

