#!/usr/bin/env bash
# Once, after the first deploy: the read-only role and the seed. Refuses to seed twice.
set -euo pipefail
cd "$(dirname "$0")/.."
psql() { docker compose exec -T db psql -v ON_ERROR_STOP=1 -U postgres -d app "$@"; }
psql < demo/readonly.sql
count=$(psql -Atc "SELECT count(*) FROM item")
if [ "$count" -lt 1000 ]; then psql < demo/seed.sql; else echo "already seeded: $count items"; fi
psql -Atc 'SELECT (SELECT count(*) FROM "user") AS users, (SELECT count(*) FROM item) AS items'
