# Forge, for the judges: a capability Unbidden did not have

This is the record behind the Forge scene in the Unbidden demo video. It is one real run, and these are the files it left.

## The result

Envoy serves 469 lines of metrics at `/stats`, in a format nothing in the system could read. Forge built a reader for it.

| Step | What happened | Record |
|---|---|---|
| Problem | 469 lines nothing could read | `forge-live.cast` |
| Local model | Denied: this workspace ran in API mode, and real data may not leave | `forge-live.cast` |
| What left the machine | 40 lines, with project names renamed and every value randomized | `egress-record.json` |
| Action | Muse Spark wrote the reader on its first attempt: two regular expressions. 1 call, US$0.0163 | `capability.json` |
| Verification, no model | 417 held-out lines the model never saw: 97.12 % coverage, 14 lines of other shapes declared unread | `capability.json` |
| In use | Read live twice: 443 readings, 257 metric kinds | `forge-live.cast` |

Real against sent, from the records:

| Metric | Real | Sent |
|---|---|---|
| `cluster_manager.cluster_added` | 1 | 29512 |
| `cluster.…membership_healthy` | 1 | 89663 |
| `cluster.…external.upstream_rq_200` | 100 | 38110 |
| `cluster.…upstream_cx_rx_bytes_total` | 31724 | 30219 |

## How to check it

```sh
asciinema play forge-live.cast     # the run
python3 -m json.tool capability.json      # the reader, its card, its tests and its quality
python3 -m json.tool egress-record.json   # exactly what was sent
```

To repeat it, install Unbidden, start `compose.yml` here with the demo app's stack running, then run `unbidden forge stats http://127.0.0.1:9901/stats` in that repository, in API mode, with a Meta API key. Results will differ slightly.

## What this does and does not show

- **A person started this command.** It ran on Unbidden v0.17.1, on a small repository holding only this Envoy, in front of the demo app. It is separate from the main demo run and not part of its US$0.15.
- **It is one format, one run, and a simple reader.** It does not show that Forge can build any integration.
- **Metric names did leave the machine**, including `teamboard_upstream`. Values did not.
- **The agent alone did not finish this.** In a second run, nobody asked and it recorded the need itself ("metrics at …/stats"). Its small local model on that machine (`llama3.2:3b`, not Muse Glimmer) failed twice, and it marked the need abandoned: `agent-noticed-need.cast`. By design, the agent alone uses only the local model here; going through the privacy bridge to Muse Spark is a person's command.
- **On the demo app itself, the gate blocked this send.** Its `user` table matched `"role": "user"` in the message envelope, so every attempt stopped before anything left: `gate-blocked-on-demo-app.cast`. That is a false alarm in the product, reported to the team, and it is why this run used a separate repository.
- **Muse Glimmer did not run here.** An earlier run with the local model is recorded in `docs/DECISIONS.md`, D-025, in [unbidden-ai](https://github.com/satisfymath/unbidden-ai): it failed eight times, and after a fix by the team it passed on 1,770 unseen lines.
