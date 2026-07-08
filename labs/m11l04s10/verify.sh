#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/oidc-deploy.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

jobs = w.get("jobs", {})
deploy_job = jobs.get("deploy", {})

# check id-token: write
perms = deploy_job.get("permissions", {})
if isinstance(perms, dict):
    if perms.get("id-token") == "write":
        print("id_token_write_ok")
    else:
        print(f"id_token_wrong: {perms.get('id-token')}")
else:
    print(f"permissions_not_dict: {perms}")

# check aws-actions/configure-aws-credentials@v4
found_aws = False
for step in deploy_job.get("steps", []):
    if "configure-aws-credentials@v4" in step.get("uses", ""):
        found_aws = True

print("aws_credentials_ok" if found_aws else "aws_credentials_missing")
PYEOF

