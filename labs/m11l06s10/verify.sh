#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/secure-ci.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# check workflow-level permissions (must be explicitly set to {})
# yaml.safe_load парсит `permissions: {}` как None (пустой mapping → None в PyYAML)
# Поэтому принимаем и None и пустой dict как эквивалент {}.
# "NOT_SET" как sentinel — отличаем явное указание permissions от его отсутствия.
_SENTINEL = object()
wf_perms = w.get("permissions", _SENTINEL)
if wf_perms is _SENTINEL:
    print("workflow_perms_wrong: permissions not set at all")
elif wf_perms is None or (isinstance(wf_perms, dict) and len(wf_perms) == 0):
    print("workflow_perms_empty_ok")
else:
    print(f"workflow_perms_wrong: {wf_perms}")

# check lint job permissions
jobs = w.get("jobs", {})
lint_job = jobs.get("lint", {})
lint_perms = lint_job.get("permissions", {})
if isinstance(lint_perms, dict) and lint_perms.get("contents") == "read":
    print("job_contents_read_ok")
else:
    print(f"job_contents_read_wrong: {lint_perms}")
PYEOF

