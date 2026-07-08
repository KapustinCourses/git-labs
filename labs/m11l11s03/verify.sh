#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/release.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

jobs = w.get("jobs", {})
test_job = jobs.get("test", {})

if not test_job:
    print("test_job_missing")
    sys.exit(0)

# check matrix
strategy = test_job.get("strategy", {})
matrix = strategy.get("matrix", {})
go_versions = matrix.get("go", [])
if len(go_versions) >= 2:
    print("matrix_go_ok")
else:
    print(f"matrix_go_wrong: {go_versions}")

# check setup-go@v6
found_setup_go = False
found_cache = False
for step in test_job.get("steps", []):
    if "setup-go@v6" in step.get("uses", ""):
        found_setup_go = True
        with_data = step.get("with", {})
        if with_data.get("cache") is True or str(with_data.get("cache", "")).lower() == "true":
            found_cache = True

print("setup_go_ok" if found_setup_go else "setup_go_missing")
print("cache_ok" if found_cache else "cache_missing")

# check permissions.contents: read
test_perms = test_job.get("permissions", {})
if isinstance(test_perms, dict) and test_perms.get("contents") == "read":
    print("contents_read_ok")
else:
    print(f"contents_read_wrong: {test_perms}")
PYEOF

