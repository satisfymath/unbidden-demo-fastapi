# Teamboard: the demo application for Unbidden

This repository is the stage for the [Unbidden](https://github.com/satisfymath/unbidden-ai) demo at the Meta Global AI
Developer Hackathon. **Unbidden itself was built during the event (October 26 to November 4, 2026). This application
was not.** It is a plain copy of [fastapi/full-stack-fastapi-template](https://github.com/fastapi/full-stack-fastapi-template)
at `f4bcfab` (MIT, see `LICENSE`).

## What was changed, and what was planted

| What | Status |
|---|---|
| `item.owner_id` has no index | **Real.** It is in the upstream template. Nothing here was added for it |
| `dnspython 2.8.0` has a known advisory | **Real.** It is in the upstream lockfile |
| `display_initials` crashes on an empty name (`backend/app/text.py`) | **Planted** for the demo |
| 2,000 customers and 200,000 items (`demo/seed.sql`) | **Staged** data |
| Simulated users (`loadtest/locustfile.py`, Locust) | **Staged** traffic, about one request a second |
| A teammate's commit that breaks the health check | **Staged** scenario, committed during the recording |
| One `compose.yml`, CI, deploy through GitHub Actions; publishing workflows and Dependabot removed | Infrastructure for the demo |

## Run it

Needs Docker with Compose, and a self-hosted GitHub Actions runner with the label `demo-fst` for deploys.

```sh
REVISION=$(git rev-parse HEAD) docker compose up -d --build --wait backend
./demo/seed.sh     # once: the read-only role and the data
```

The app is at <http://127.0.0.1:8100>. Sign in as `customer1@example.com` with `demo-password`. Every credential in this
repository is a local demo value bound to 127.0.0.1.

## Deploys

`scripts/deploy-via-github.sh` asks GitHub Actions to deploy the checked-out commit and waits for the verdict. The
workflow (`.github/workflows/deploy.yml`) runs only on dispatch, on the runner of this machine. Pull requests run on
GitHub's machines (`.github/workflows/test-backend.yml`).
