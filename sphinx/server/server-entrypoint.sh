#!/bin/bash
set -e

THREADS=${1:-1}
WARMUPREQS=${2:-1000}
MAXREQS=${3:-2000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

exec /decoder_server_networked -t "$THREADS"
