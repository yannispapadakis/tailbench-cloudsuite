#!/bin/bash

THREADS=${1:-1}
WARMUPREQS=${2:-5000}
MAXREQS=${3:-5000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

# The server exits after WARMUPREQS+MAXREQS requests. Restart it here instead of letting
# kubelet restart the container: runs are much shorter than 10 min, so kubelet's restart
# back-off (10 s doubling up to 5 min) would keep growing in a co-execution, where the
# shorter benchmark reruns until the longer one finishes. The client retries until the
# restarted server listens again.
trap 'kill $pid 2>/dev/null; exit 0' TERM INT
while true; do
    /moses_server_networked -config /moses.ini \
        -input-file /opt/tailbench.inputs/moses/testTerms \
        -threads "$THREADS" -num-tasks 1000000 -verbose 0 &
    pid=$!
    wait $pid
    sleep 1
done
