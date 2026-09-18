# Original client image (built from sources that no longer exist), pinned by digest.
FROM ioannispapadakis/web-search@sha256:712648adec3deb44666606e8cc828c16bc6b0da7127e04d604db04dcf0ad294d

# Only change: query.sh no longer overrides SOLR_PORT with a hard-coded 8983
# (docker-entrypoint.py already reads SOLR_PORT from the environment; image default 8983).
COPY query.sh /query.sh
