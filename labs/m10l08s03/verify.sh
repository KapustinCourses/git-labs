#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
lint = w['jobs']['lint']
steps = lint.get('steps', [])
has_golangci = any('golangci-lint-action@v9' in str(s.get('uses','')) for s in steps)
print(f'lint_steps_count={len(steps)}')
print(f'has_golangci_lint={has_golangci}')
"

