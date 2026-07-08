#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

# Try to load and validate YAML
try:
    with open(".github/workflows/release.yml") as f:
        w = yaml.safe_load(f)
    print("yaml_valid")
except Exception as e:
    print(f"yaml_invalid: {e}")
    sys.exit(0)

# check concurrency
c = w.get("concurrency", {})
if isinstance(c, dict) and c.get("group"):
    print("concurrency_ok")
else:
    print("concurrency_missing")

# check all 3 jobs exist
jobs = w.get("jobs", {})
required_jobs = {"test", "docker", "deploy"}
if required_jobs <= set(jobs.keys()):
    print("all_jobs_ok")
else:
    missing = required_jobs - set(jobs.keys())
    print(f"jobs_missing: {missing}")

# check workflow-level permissions: {}
perms = w.get("permissions", "NOT_SET")
if isinstance(perms, dict) and len(perms) == 0:
    print("permissions_empty_ok")
else:
    print(f"permissions_wrong: {perms}")
PYEOF

