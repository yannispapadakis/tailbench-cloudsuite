FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY build/moses_client_networked /moses_client_networked
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh /moses_client_networked

WORKDIR /data
ENTRYPOINT ["/client-entrypoint.sh"]
