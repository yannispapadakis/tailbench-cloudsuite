#!/bin/bash
set -e

THREADS=${1:-1}
WARMUPREQS=${2:-5000}
MAXREQS=${3:-5000}

export TBENCH_WARMUPREQS=$WARMUPREQS
export TBENCH_MAXREQS=$MAXREQS

exec /moses_server_networked -config /moses.ini \
    -input-file /opt/tailbench.inputs/moses/testTerms \
    -threads "$THREADS" -num-tasks 1000000 -verbose 0
