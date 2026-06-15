FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        libopencv-core3.2 \
        python3 \
        python3-numpy \
    && rm -rf /var/lib/apt/lists/*

COPY img-dnn_client_networked /img-dnn_client_networked
COPY mnist /opt/mnist
COPY lats_summary.py /lats_summary.py
COPY client-entrypoint.sh /client-entrypoint.sh
RUN chmod +x /client-entrypoint.sh

WORKDIR /tmp
ENTRYPOINT ["/client-entrypoint.sh"]
