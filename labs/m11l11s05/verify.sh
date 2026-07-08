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
deploy_job = jobs.get("deploy", {})

if not deploy_job:
    print("deploy_job_missing")
    sys.exit(0)

# check needs: [docker]
needs = deploy_job.get("needs", [])
if isinstance(needs, str):
    needs = [needs]
if "docker" in needs:
    print("needs_docker_ok")
else:
    print(f"needs_docker_missing: {needs}")

# check environment: production
env = deploy_job.get("environment", "")
if env == "production":
    print("env_production_ok")
else:
    print(f"env_production_wrong: {env}")

# check permissions.id-token: write
perms = deploy_job.get("permissions", {})
if isinstance(perms, dict) and perms.get("id-token") == "write":
    print("id_token_write_ok")
else:
    print(f"id_token_write_missing: {perms}")

# check aws-actions/configure-aws-credentials@v4
found_aws = False
for step in deploy_job.get("steps", []):
    if "configure-aws-credentials@v4" in step.get("uses", ""):
        found_aws = True

print("aws_credentials_ok" if found_aws else "aws_credentials_missing")
PYEOF

