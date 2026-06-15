#!/bin/bash
set -e

THREADS=${1:-1}
WAREHOUSES=${2:-1}
WARMUPREQS=${3:-20000}
MAXREQS=${4:-20000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

exec /dbtest_server_networked --verbose --bench tpcc --num-threads "$THREADS" \
    --scale-factor "$WAREHOUSES" --retry-aborted-transactions --ops-per-worker 10000000
