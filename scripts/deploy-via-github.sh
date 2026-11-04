#!/usr/bin/env bash
# The team's deploy: asks GitHub Actions to deploy the commit checked out here, and waits for the verdict.
# The run happens on the self-hosted runner of this machine; this script fails when the deploy fails.
set -euo pipefail

sha=$(git rev-parse HEAD)
repo=satisfymath/unbidden-demo-fastapi
since=$(date -u +%Y-%m-%dT%H:%M:%SZ)

gh workflow run deploy.yml -R "$repo" --ref main -f sha="$sha"

run=""
for _ in $(seq 1 30); do
  run=$(gh run list -R "$repo" --workflow deploy.yml --event workflow_dispatch --limit 1 \
    --created ">=$since" --json databaseId --jq '.[0].databaseId // empty')
  [ -n "$run" ] && break
  sleep 2
done
[ -n "$run" ] || { echo "the deploy run of $sha did not appear" >&2; exit 1; }

echo "deploying ${sha:0:12}: https://github.com/$repo/actions/runs/$run"
gh run watch "$run" -R "$repo" --exit-status --interval 5 >/dev/null
