#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".gitlab-ci.yml") as f:
        c = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# check stages
stages = c.get("stages", [])
if "lint" in stages and "test" in stages and "build" in stages:
    print("stages_ok")
else:
    print(f"stages_wrong: {stages}")

# check jobs (lint-job, test-job, build-job are expected, but also allow other names)
# Find jobs by their stage field
jobs_by_stage = {}
for key, val in c.items():
    if isinstance(val, dict) and "stage" in val:
        stage = val.get("stage")
        jobs_by_stage.setdefault(stage, []).append(key)

print("lint_job_ok" if jobs_by_stage.get("lint") else "lint_job_missing")
print("test_job_ok" if jobs_by_stage.get("test") else "test_job_missing")
print("build_job_ok" if jobs_by_stage.get("build") else "build_job_missing")
PYEOF

