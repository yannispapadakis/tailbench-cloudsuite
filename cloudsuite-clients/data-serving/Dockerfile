# Original client image (built from sources that no longer exist), pinned by digest.
FROM ioannispapadakis/data-serving@sha256:e599a6d31c2b34a28ca3c113ce4ecca4d27c192734693873c41ac4f759887f62

# Only change: cqlsh and YCSB take the Cassandra native port from CASSANDRA_PORT (default 9042).
COPY warmup.sh /warmup.sh
COPY load.sh /load.sh
