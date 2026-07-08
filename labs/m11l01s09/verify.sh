#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/pipeline.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

jobs = w.get("jobs", {})

# check upload-artifact in build
build_job = jobs.get("build", {})
found_upload = False
for step in build_job.get("steps", []):
    if "upload-artifact@v4" in step.get("uses", ""):
        with_data = step.get("with", {})
        if with_data.get("name") == "binaries" and "dist" in str(with_data.get("path", "")):
            if with_data.get("retention-days") == 7:
                found_upload = True
if found_upload:
    print("upload_ok")
    print("retention_ok")
else:
    # try to be more lenient - check just upload-artifact exists
    for step in build_job.get("steps", []):
        if "upload-artifact@v4" in step.get("uses", ""):
            print("upload_ok")
            with_data = step.get("with", {})
            if with_data.get("retention-days") == 7:
                print("retention_ok")
            else:
                print(f"retention_missing: {with_data.get('retention-days')}")
            break
    else:
        print("upload_missing")

# check download-artifact in deploy
deploy_job = jobs.get("deploy", {})
for step in deploy_job.get("steps", []):
    if "download-artifact@v4" in step.get("uses", ""):
        print("download_ok")
        break
else:
    print("download_missing")

# check needs
needs = deploy_job.get("needs", [])
if isinstance(needs, str):
    needs = [needs]
if "build" in needs:
    print("needs_ok")
else:
    print(f"needs_missing: {needs}")
PYEOF

