#!/bin/bash

THREADS=${1:-4}
WARMUPREQS=${2:-5000}
MAXREQS=${3:-10000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

# -n controls the worker request loop; set far above warmup+ROI so the
# harness (TBENCH_WARMUPREQS/TBENCH_MAXREQS) is what ends the run.
# The server exits after WARMUPREQS+MAXREQS requests. Restart it here instead of letting
# kubelet restart the container: runs are much shorter than 10 min, so kubelet's restart
# back-off (10 s doubling up to 5 min) would keep growing in a co-execution, where the
# shorter benchmark reruns until the longer one finishes. The client retries until the
# restarted server listens again.
trap 'kill $pid 2>/dev/null; exit 0' TERM INT
while true; do
    /img-dnn_server_networked -r "$THREADS" -f /opt/model.xml -n 100000000 &
    pid=$!
    wait $pid
    sleep 1
done
