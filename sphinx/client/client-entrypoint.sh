#!/bin/bash
set -e

IP=$1
QPS=$2

export TBENCH_SERVER=$IP
export TBENCH_SERVER_PORT=${TBENCH_SERVER_PORT:-8080}
export TBENCH_QPS=$QPS
export TBENCH_CLIENT_THREADS=${TBENCH_CLIENT_THREADS:-1}
export TBENCH_MINSLEEPNS=${TBENCH_MINSLEEPNS:-10000}
export TBENCH_RANDSEED=${TBENCH_RANDSEED:-100}
export TBENCH_AN4_CORPUS=/opt/tailbench.inputs/sphinx
export TBENCH_AUDIO_SAMPLES=/opt/tailbench.inputs/sphinx/audio_samples

# The server only accepts TBENCH_NCLIENTS (default 1) connections, so we
# can't probe the port separately without consuming that slot. Instead,
# retry the client itself: a connection refused (server not listening yet)
# exits without writing lats.bin, so just retry.
rm -f lats.bin
for i in $(seq 1 60); do
    if /decoder_client_networked && [ -f lats.bin ]; then
        break
    fi
    sleep 1
done

python3 /lats_summary.py lats.bin
