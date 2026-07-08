#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
concurrency = w.get('concurrency', {})
has_concurrency = bool(concurrency)
cancel = concurrency.get('cancel-in-progress', False) if concurrency else False
print(f'has_concurrency={has_concurrency}')
print(f'cancel_in_progress={cancel}')
"

