#!/usr/bin/env bash
set -euo pipefail
python3 -c "
import yaml
with open('.github/workflows/ci.yml') as f:
    w = yaml.safe_load(f)
job = next(iter(w.get('jobs', {}).values()), {})
steps = job.get('steps', [])
env_steps = [s for s in steps if s.get('env')]
has_env = bool(env_steps)
# Проверяем что run использует \$VAR но не \${{ в самом run
run_steps = [s for s in steps if s.get('run')]
shell_var = any('\$COMMIT_MSG' in str(s.get('run', '')) or '\${COMMIT_MSG}' in str(s.get('run', '')) for s in run_steps)
no_expr = not any('\${{' in str(s.get('run', '')) for s in run_steps)
print(f'has_env_block={has_env}')
print(f'run_uses_shell_var={shell_var}')
print(f'run_no_expression={no_expr}')
"

