#!/usr/bin/env bash
# Our own measurement of the live app, not Unbidden's: the median of 30 signed-in requests to the items list.
set -euo pipefail
base=http://127.0.0.1:8100/api/v1
token=$(curl -s -d 'username=customer7@example.com&password=demo-password' "$base/login/access-token" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')
for _ in $(seq 1 30); do
  curl -s -o /dev/null -w '%{time_total}\n' -H "Authorization: Bearer $token" "$base/items/?limit=20"
done | sort -n | awk '{a[NR]=$1} END {printf "GET /items/ median of %d requests: %.1f ms\n", NR, a[int((NR+1)/2)]*1000}'
