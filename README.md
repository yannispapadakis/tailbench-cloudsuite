# tailbench-docker

Docker build contexts and Kubernetes entrypoint scripts for the
[TailBench v0.9](https://tailbench.csail.mit.edu/) (Kasture & Sanchez,
IISWC-2016) latency-critical benchmark suite. These images are used as
`bench_library` entries by the `delphi-execute` benchmarking suite
(`suites.py`), running each app's server as a `Deployment` and its load
generator as a `Job`, following TailBench's "networked" harness mode.

## Apps

| App | Description |
| --- | --- |
| `img-dnn`  | Image classification (OpenCV + MNIST) |
| `masstree` | Key-value store queries |
| `silo`     | In-memory OLTP database (TPC-C) |
| `sphinx`   | Speech recognition |
| `moses`    | Statistical machine translation |

Each app has a `server/` and `client/` build context with a `Dockerfile` and
an `*-entrypoint.sh` that translates CLI args into `TBENCH_*` environment
variables expected by the TailBench harness. The client image also ships
`lats_summary.py`, a trimmed (numpy-only) replacement for TailBench's
`parselats.py` that prints latency percentiles from `lats.bin`.

## Prerequisite: extract.sh

The prebuilt TailBench binaries and datasets (`*_networked` executables,
`build/` object files, `model.xml`, MNIST images, language models, etc.) are
**not included** in this repo — they're pulled from a local TailBench v0.9
archive (binaries + `tailbench.inputs/`, e.g. as produced by
[tailbench](https://github.com/yiwenzhang92/tailbench) or the TailBench
release tarball):

```bash
./extract.sh /path/to/tailbench.tar.gz
```

This populates the `.gitignore`'d paths under each app's `server/`/`client/`
directories, after which `docker build` works for each
`<app>/server/Dockerfile` and `<app>/client/Dockerfile`.

## License

TailBench's own harness/utility code is MIT licensed (Copyright (C) 2016
Massachusetts Institute of Technology). The underlying benchmark engines
(masstree, silo, moses, etc.) carry their own upstream licenses — see
TailBench's `LICENSE` file for details. This repo contains only our own
Dockerfiles, entrypoint scripts, and `lats_summary.py`, not TailBench's code
or data.
