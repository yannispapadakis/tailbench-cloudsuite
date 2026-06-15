#!/bin/bash
set -e

THREADS=${1:-1}
WARMUPREQS=${2:-5000}
MAXREQS=${3:-10000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

exec /mttest_server_networked -j"$THREADS" mycsba masstree
