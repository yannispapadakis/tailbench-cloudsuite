# Original client image (built from sources that no longer exist), pinned by digest.
FROM ioannispapadakis/data-caching@sha256:3c9d5ea3aaff4337cf592ea5b7cadb0d41e675afd17ac4885745862e323bb475

# Only change: the memcached server port comes from MEMCACHED_PORT (default 11211).
COPY --chown=999:999 entrypoint.sh /usr/src/memcached/entrypoint.sh
