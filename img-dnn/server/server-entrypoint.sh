#!/bin/bash
set -e

THREADS=${1:-4}
WARMUPREQS=${2:-5000}
MAXREQS=${3:-10000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

# -n controls the worker request loop; set far above warmup+ROI so the
# harness (TBENCH_WARMUPREQS/TBENCH_MAXREQS) is what ends the run.
exec /img-dnn_server_networked -r "$THREADS" -f /opt/model.xml -n 100000000
