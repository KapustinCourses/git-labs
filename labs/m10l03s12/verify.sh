#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/deploy.yml') as f:
    w = yaml.safe_load(f)
on_val = w.get('on') or w.get(True)
dispatch = on_val.get('workflow_dispatch', {}) if isinstance(on_val, dict) else {}
has_dispatch = bool(dispatch is not None)
inputs = dispatch.get('inputs', {}) if dispatch else {}
env_input = inputs.get('environment', {}) if inputs else {}
print(f'has_dispatch={has_dispatch}')
print(f'input_name={\"environment\" if \"environment\" in (inputs or {}) else \"missing\"}')
print(f'input_type={env_input.get(\"type\", \"missing\")}')
"

