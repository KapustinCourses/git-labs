#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys, re

try:
    with open(".github/workflows/ci.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# check matrix
try:
    job = list(w["jobs"].values())[0]
    strategy = job.get("strategy", {})
    matrix = strategy.get("matrix", {})
    if "os" in matrix and "node" in matrix:
        print("matrix_ok")
    else:
        print(f"matrix_missing: keys={list(matrix.keys())}")
except Exception as e:
    print(f"matrix_error: {e}")

# check fail-fast
try:
    job = list(w["jobs"].values())[0]
    strategy = job.get("strategy", {})
    ff = strategy.get("fail-fast", True)
    if ff is False:
        print("fail_fast_ok")
    else:
        print(f"fail_fast_wrong: {ff}")
except Exception as e:
    print(f"fail_fast_error: {e}")

# check upload-artifact
try:
    found = False
    for jname, jdata in w["jobs"].items():
        for step in jdata.get("steps", []):
            uses = step.get("uses", "")
            if "upload-artifact@v4" in uses:
                found = True
    if found:
        print("upload_artifact_ok")
    else:
        print("upload_artifact_missing")
except Exception as e:
    print(f"upload_artifact_error: {e}")
PYEOF

