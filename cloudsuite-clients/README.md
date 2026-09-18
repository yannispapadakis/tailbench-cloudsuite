# CloudSuite client image patches

The original build sources of these client images are gone; each directory rebuilds
`ioannispapadakis/<bench>:client` from the original image (pinned by digest) with one
script patched so the client can reach a server whose NodePort was shifted by the
framework (`port_offset` in delphi's `execute/suites.py`, passed as `DELPHI_PORT_OFFSET`).

| Image | Port variable (default) | Patched file |
|---|---|---|
| data-caching:client | `MEMCACHED_PORT` (11211) | `/usr/src/memcached/entrypoint.sh` |
| data-serving:client | `CASSANDRA_PORT` (9042) | `/warmup.sh`, `/load.sh` |
| web-search:client | `SOLR_PORT` (8983) | `/query.sh` |

media-streaming:client needs no image change: its ports are already arguments (`--p`, `--tp`).

Build and push: `docker build -t ioannispapadakis/<bench>:client <bench> && docker push ioannispapadakis/<bench>:client`
