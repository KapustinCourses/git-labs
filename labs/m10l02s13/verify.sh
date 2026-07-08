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
elif isinstance(on_val, str):
    triggers = [on_val]
else:
    triggers = []
print(f'triggers={chr(44).join(triggers)}')
"

