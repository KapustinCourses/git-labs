#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
on_val = w.get('on') or w.get(True)
if isinstance(on_val, list):
    triggers = sorted(on_val)
elif isinstance(on_val, dict):
    triggers = sorted(on_val.keys())
else:
    triggers = [str(on_val)]
lint = w.get('jobs', {}).get('lint', {})
steps = lint.get('steps', [])
has_checkout = any('checkout@v6' in str(s.get('uses','')) for s in steps)
has_setup_go = any('setup-go@v6' in str(s.get('uses','')) for s in steps)
print(f'triggers={chr(44).join(triggers)}')
print(f'has_lint_job={bool(lint)}')
print(f'lint_has_checkout={has_checkout}')
print(f'lint_has_setup_go={has_setup_go}')
"

