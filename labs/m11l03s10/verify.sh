#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/deploy.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_secret_in_env = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        env_block = step.get("env", {})
        if isinstance(env_block, dict):
            for val in env_block.values():
                if isinstance(val, str) and "secrets." in val:
                    found_secret_in_env = True
        run_cmd = step.get("run", "")
        # make sure secret is NOT directly in run command (bad pattern)
        # we check that it's in env, not in run
        if "secrets.MY_TOKEN" in str(run_cmd):
            print("secret_in_run_direct")

if found_secret_in_env:
    print("secret_in_env_ok")
else:
    print("secret_in_env_missing")
PYEOF

